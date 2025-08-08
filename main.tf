# Configure Terraform to use AWS as the provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3"

  # Configure backend on AWS S3
  # This is where the state file will be stored
  backend "s3" {
    bucket  = "distinctioncoding-tfstatefilebucket"
    key     = "dev/wendy/terraform-alb-app/terraform.tfstate"
    region  = "ap-southeast-2"
    encrypt = true
  }
}

# Configure the region for the AWS provider
provider "aws" {
  region = var.aws_region
}

# Declare variables for the security group of alb
module "alb_sg" {
  source      = "./modules/security_group"
  sg_name     = "${var.name_prefix}-alb-sg"
  description = "Allow HTTP from Internet"
  vpc_id      = var.vpc_id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

# Declare variables for the security group of bastion host
module "bastion_sg" {
  source      = "./modules/security_group"
  sg_name     = "${var.name_prefix}-bastion-sg"
  description = "Allow SSH from my IP only"
  vpc_id      = var.vpc_id
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.my_ip_cidr]
      description = "Allow SSH from my IP"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

# Declare variables for the security group of app server
module "app_sg" {
  source      = "./modules/security_group"
  sg_name     = "${var.name_prefix}-app-sg"
  description = "Allow HTTP from ALB & SSH from Bastion Host"
  vpc_id      = var.vpc_id
  ingress_rules = [
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      security_groups = [module.bastion_sg.sg_id]
      description     = "Allow SSH from Bastion Host"
    },
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.alb_sg.sg_id]
      description     = "Allow HTTP from ALB SG"
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

# Declare variables for the NAT gateway
module "nat_gateway" {
  source                   = "./modules/nat_gateway"
  vpc_id                   = var.vpc_id
  public_subnet_ids        = var.public_subnet_ids
  private_subnet_id        = var.private_subnet_id
  private_route_table_name = var.private_route_table_name
  name_prefix              = var.name_prefix
}

# Declare variables for the App Server(private subnet)
module "app_server" {
  source                      = "./modules/ec2_instance"
  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.private_subnet_id
  sg_id                       = module.app_sg.sg_id
  instance_name               = "${var.name_prefix}-app-server"
  associate_public_ip_address = false
  enable_user_data            = true
  user_data                   = <<-EOF
    #!/bin/bash

    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sysctl -w net.ipv6.conf.lo.disable_ipv6=1

    echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.lo.disable_ipv6=1" >> /etc/sysctl.conf

    echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

    apt-get update -y
    apt-get install -y docker.io

    systemctl start docker
    systemctl enable docker

    docker run -d -p 80:80 python:3.9-slim /bin/sh -c "echo 'Hello World!' > index.html && python -m http.server 80"
  EOF
}

# Declare variables for the Bastion Host(public subnet)
module "bastion_host" {
  source                      = "./modules/ec2_instance"
  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_ids[0]
  sg_id                       = module.bastion_sg.sg_id
  instance_name               = "${var.name_prefix}-bastion-host"
  associate_public_ip_address = true
  enable_user_data            = false
}

# Declare variables for the ALB
module "alb" {
  source             = "./modules/alb"
  vpc_id             = var.vpc_id
  public_subnet_ids  = var.public_subnet_ids
  alb_sg_id          = module.alb_sg.sg_id
  target_instance_id = module.app_server.instance_id
  name_prefix        = var.name_prefix
}