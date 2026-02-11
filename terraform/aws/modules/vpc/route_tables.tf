resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.environment}-public-route-table"
  }
}

resource "aws_route_table" "private_routes" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.environment}-private-route-table"
  }
}

# Public route via IGW
resource "aws_route" "public_igw" {
  count = var.create_internet_gateway ? 1 : 0

  route_table_id         = aws_route_table.public_routes.id
  gateway_id             = aws_internet_gateway.igw[0].id # use [0] because of count
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [
    aws_internet_gateway.igw
  ]
}

# Private route via NAT
resource "aws_route" "private_nat" {
  count = var.create_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_routes.id
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [
    aws_nat_gateway.nat_gw
  ]
}


resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_routes.id
}