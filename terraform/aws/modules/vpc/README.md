# 🌐 Terraform VPC Networking Module

This module deploys a fully configurable **VPC networking stack** on AWS including:

- VPC with DNS hostnames enabled
- Public & Private subnets across multiple Availability Zones
- Internet Gateway (optional)
- NAT Gateway (optional) with Elastic IP
- Public & Private Route Tables + Associations
- Default Security Group with customizable rules

> 🏗️ Designed for use with Terraform or Terragrunt.

---

## 📌 Features

| Feature | Supported |
|--------|-----------|
| Create Custom VPC | ✅ |
| Public Subnets | ✅ |
| Private Subnets | ✅ |
| Internet Gateway (IGW) toggle | 🔄 Optional |
| NAT Gateway toggle | 🔄 Optional |
| Default Security Group with custom rules | 🔐 Yes |
| Multi-AZ public/private mapping | 🌍 Yes |

---

## 🛠️ Module Inputs (Variables)

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region_name` | string | none | AWS Region for deployment |
| `vpc_cidr_block` | string | none | CIDR block for the VPC |
| `environment` | string | none | Environment name (e.g., `dev`, `stage`, `prod`) |
| `public_subnets` | map(string) | none | Map of AZ → CIDR for public subnets |
| `private_subnets` | map(string) | none | Map of AZ → CIDR for private subnets |
| `sg_ingress_rules` | list(object) | none | List of ingress security rules |
| `sg_egress_rules` | list(object) | none | List of egress security rules |
| `create_internet_gateway` | bool | `true` | Whether to deploy IGW |
| `create_nat_gateway` | bool | `true` | Whether to deploy NAT GW |

---

## Example Terraform Variables `terraform.tfvars`

```hcl
region_name      = "us-east-1"
environment      = "Staging"
vpc_cidr_block   = "10.20.0.0/16"

public_subnets = {
  "us-east-1a" = "10.20.0.0/24"
  "us-east-1b" = "10.20.2.0/24"
}

private_subnets = {
  "us-east-1a" = "10.20.1.0/24"
  "us-east-1b" = "10.20.3.0/24"
}

sg_ingress_rules = [
  { port = 22,  protocol = "tcp", cidr_block = "0.0.0.0/0", description = "SSH Access" },
  { port = 80,  protocol = "tcp", cidr_block = "0.0.0.0/0", description = "HTTP Access" }
]

# Optional (default already allows all outbound)
sg_egress_rules = [
  { port = 0, protocol = "-1", cidr_block = "0.0.0.0/0", description = "Allow All Outbound" }
]

# Gateway options
create_internet_gateway = false
create_nat_gateway      = false
```

## Example Terraform Module `main.tf`

```hcl
module "vpc_network" {
  source = "./modules/vpc-network"

  region_name     = var.region_name
  environment     = var.environment
  vpc_cidr_block  = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  sg_ingress_rules = var.sg_ingress_rules
  sg_egress_rules  = var.sg_egress_rules

  create_internet_gateway = true
  create_nat_gateway      = true
}
```

## Example Terragrunt `terragrunt.hcl`

```hcl
terraform {
    source = "git::git@github.com:senvishal02/terraform.git//aws/modules/vpc?ref=v1.0.0"
}

locals {
  region = "us-east-1"
}

inputs = {
  region_name     = local.region
  environment     = "development"
  vpc_cidr_block  = "10.30.0.0/16"

  public_subnets = {
    "${local.region}a" = "10.30.0.0/24"
    "${local.region}b" = "10.30.2.0/24"
  }

  private_subnets = {
    "${local.region}a" = "10.30.1.0/24"
    "${local.region}b" = "10.30.3.0/24"
  }

  sg_ingress_rules = [
    { port = 22,  protocol = "tcp", cidr_block = "0.0.0.0/0", description = "Allow SSH" },
  ]

  sg_egress_rules = [
    { port = 0, protocol = "-1", cidr_block = "0.0.0.0/0", description = "Allow all outbound" },
  ]

  create_internet_gateway = false
  create_nat_gateway      = false
}
```