resource "aws_nat_gateway" "nat_gw" {
  count = var.create_nat_gateway ? 1 : 0

  subnet_id     = element(aws_subnet.public_subnets.*.id, 0) # first public subnet
  allocation_id = element(aws_eip.nat_eip.*.id, 0)           # first EIP allocation

  depends_on = [
    aws_subnet.public_subnets,
    aws_eip.nat_eip
  ]

  tags = {
    Name = "${var.environment}-nat-gw"
  }
}
