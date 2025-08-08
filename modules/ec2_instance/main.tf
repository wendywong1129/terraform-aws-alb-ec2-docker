resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  user_data = var.enable_user_data && var.user_data != "" ? var.user_data : null

  tags = {
    Name = var.instance_name
  }
}