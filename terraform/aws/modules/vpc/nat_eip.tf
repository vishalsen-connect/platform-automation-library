resource "aws_eip" "nat_eip" {
  count = var.create_nat_gateway ? 1 : 0

  tags = {
    Name = "${var.environment}-nat-eip"
  }
}
