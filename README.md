# terraform-aws-alb-ec2-docker

A Terraform project to deploy a secure and scalable AWS environment with:

- **Application Load Balancer (ALB)**
- **EC2 instances** running Docker
- Automated Docker installation via `user_data`
- Security groups, NAT Gateway, and Bastion Host for secure SSH access

## 📌 Features
- Deploys an **ALB** with listeners and target groups
- Launches **EC2 instances** in private subnets, pre-configured with Docker
- Creates a **Bastion Host** in a public subnet for SSH access
- Configures **Security Groups** to allow controlled inbound/outbound traffic
- **Terraform modules** structure for maintainability

## 🛠️ Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0.0
- AWS account credentials configured (`aws configure`)
- An existing AWS VPC or let Terraform create a new one
- SSH key pair in AWS (update variables accordingly)

## 🚀 Deployment
```bash
# Clone the repository
git clone https://github.com/wendywong1129/terraform-aws-alb-ec2-docker.git
cd terraform-aws-alb-ec2-docker

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

🔐 Accessing the Bastion Host
ssh -i your-key.pem ubuntu@<Bastion_Public_IP>
From the Bastion Host, you can SSH into private EC2 instances:
ssh -i your-key.pem ubuntu@<Private_EC2_IP>

📂 Project Structure
terraform-aws-alb-ec2-docker/
├── main.tf                # Main Terraform configuration
├── variables.tf           # Input variables
├── outputs.tf             # Output values
├── modules/
│   ├── alb/               # ALB module
│   ├── ec2_instance/      # EC2 module with Docker setup
│   ├── bastion/           # Bastion host module
│   └── security_group/    # Security group module
└── README.md

🧹 Cleanup
To destroy all resources:
terraform destroy

📜 License
This project is licensed under the MIT License.
