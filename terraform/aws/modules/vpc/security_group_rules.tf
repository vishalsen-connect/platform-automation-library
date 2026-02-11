# Ingress rules
resource "aws_security_group_rule" "ingress" {
  for_each = { for i, r in var.sg_ingress_rules : i => r }

  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.default_sg.id
  description       = each.value.description
}

# Egress rules
resource "aws_security_group_rule" "egress" {
  for_each = { for i, r in var.sg_egress_rules : i => r }

  type              = "egress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.default_sg.id
  description       = each.value.description
}
