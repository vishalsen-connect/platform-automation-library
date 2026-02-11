resource "aws_security_group" "default_sg" {
  name   = "${var.environment}-default-sg"
  vpc_id = aws_vpc.vpc.id

  depends_on = [aws_vpc.vpc]

  tags = {
    "Name" = "${var.environment}-default-sg"
  }
}