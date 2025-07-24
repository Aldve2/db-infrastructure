variable "vpc_id" {
  description = "VPC ID to attach SG"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "security_groups" {
  type = map(object({
    name          = string
    description   = string
    ingress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

