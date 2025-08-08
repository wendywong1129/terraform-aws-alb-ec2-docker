output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "nat_eip" {
  description = "Elastic IP allocated for NAT Gateway"
  value       = aws_eip.nat.public_ip
}