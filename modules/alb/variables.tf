variable "vpc_id" {
  description = "VPC ID where the ALB and target group reside"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "target_instance_id" {
  description = "EC2 instance ID to attach to the target group"
  type        = string
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "wendy"
}