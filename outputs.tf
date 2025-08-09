output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.dns_name
}

output "bastion_public_ip" {
  description = "Public IP address of the Bastion Host"
  value       = module.bastion_host.public_ip
}

output "app_server_private_ip" {
  description = "Private IP address of the App Server"
  value       = module.app_server.private_ip
}

output "app_server_instance_id" {
  description = "Instance ID of the App Server"
  value       = module.app_server.instance_id
}