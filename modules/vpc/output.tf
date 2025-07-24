output "vpc_id" {
  description = "ID for VPC"
  value       = aws_vpc.vpc_crm.id
}
output "vpc_cidr" {
  description = "CIDR block for VPC"
  value = var.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnets IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnets IDs"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  description = "NAT Gateways IDs"
  value       = aws_nat_gateway.natgw[*].id
}