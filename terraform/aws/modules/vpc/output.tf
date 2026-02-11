# 🆔 VPC ID created for EKS Cluster
output "vpc_id" {
  description = "ID of the VPC provisioned for hosting the EKS cluster and its associated resources"
  value       = aws_vpc.eks_vpc.id
}

# 🌍 Public Subnets used by EKS Nodes
output "public_subnets" {
  description = "IDs of the public subnets available for EKS public-facing components or load balancers"
  value       = aws_subnet.eks_public_subnets[*].id
}

# 🔐 Private Subnets used by EKS Worker Nodes
output "private_subnets" {
  description = "IDs of the private subnets where EKS worker nodes will be deployed"
  value       = aws_subnet.eks_private_subnets[*].id
}

# 🛡 Default Security Group for EKS Control Plane
output "default_sg_id" {
  description = "ID of the default security group used by the EKS control plane components"
  value       = aws_security_group.default_group.id
}
