provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "vpc_crm" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = { Name = "multi-az-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_crm.id
  tags = { Name = "vpc-igw" }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = length(var.azs)
}

# NAT Gateway AZ
resource "aws_nat_gateway" "natgw" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = { Name = "nat-${var.azs[count.index]}" }
  depends_on = [aws_internet_gateway.igw]
}

# publics subnets
resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.vpc_crm.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${var.azs[count.index]}"
  }
}

# private subnets
resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.vpc_crm.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "private-${var.azs[count.index]}"
  }
}

# public Route table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_crm.id
  tags = { Name = "public-rt" }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route tables 
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.vpc_crm.id
  tags = {
    Name = "private-rt-${var.azs[count.index]}"
  }
}

resource "aws_route" "private_nat_route" {
  count                  = length(var.azs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[count.index].id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
