variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (e.g., t2.micro)"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet ID where EC2 instance will be deployed"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID attached to the EC2 instance"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type = string
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public IP"
  type = bool
  default = false
}

variable "enable_user_data" {
  description = "Whether to enable App Server user data script"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "User data script content (optional)"
  type        = string
  default     = ""
}