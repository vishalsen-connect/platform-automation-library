# ⚙️ Region where resources will be deployed
variable "region_name" {
  description = "AWS Region in which the infrastructure will be deployed (e.g., us-east-1)"
  type        = string
}

# 🌐 CIDR Block for VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC (e.g., 10.20.0.0/16)"
  type        = string
}

# 🏷️ Environment Tag
variable "environment" {
  description = "Deployment environment name (e.g., dev, stage, prod)"
  type        = string
}

# 🌍 Public Subnets (AZ to CIDR mapping)
variable "public_subnets" {
  description = "Map of public subnet CIDR blocks where key = availability zone and value = CIDR block"
  type        = map(string)
}

# 🔐 Private Subnets (AZ to CIDR mapping)
variable "private_subnets" {
  description = "Map of private subnet CIDR blocks where key = availability zone and value = CIDR block"
  type        = map(string)
}

# 🚪 Security Group Ingress Rules
variable "sg_ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    port        = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
}

# 🔄 Security Group Egress Rules
variable "sg_egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    port        = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
}

# 🌏 Internet Gateway Creation Toggle
variable "create_internet_gateway" {
  description = "Whether to create an Internet Gateway for the public subnets"
  type        = bool
  default     = true
}

# 🔁 NAT Gateway Creation Toggle
variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway for private subnets"
  type        = bool
  default     = true
}
