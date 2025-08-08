resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_ids[0] 
  tags = {
    Name = "${var.name_prefix}-nat-gateway"
  }
}

data "aws_route_tables" "private" {
 filter {
 name = "tag:Name"
 values = [var.private_route_table_name]
 }
}

resource "aws_route" "private_to_nat" {
  route_table_id         = data.aws_route_tables.private.ids[0]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}