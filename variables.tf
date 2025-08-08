variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name to use for SSH"
  type        = string
}

variable "my_ip_cidr" {
  description = "My public IP address with /32 for SSH access"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for EC2"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets IDs for ALB and IGW"
  type        = list(string)
}

variable "private_route_table_id" {
  description = "Existing route table ID associated with the private subnet"
  type        = string
}

variable "public_route_table_id" {
  description = "Existing route table ID associated with the public subnet"
  type        = string
}

variable "private_route_table_name" {
  description = "Name tag of private route table to update with NAT route"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "wendy"
}