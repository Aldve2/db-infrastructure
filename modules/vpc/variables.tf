variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "azs" {
  description = "Multi AZ zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets for each AZ"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnets for each AZ"
  type        = list(string)
}

