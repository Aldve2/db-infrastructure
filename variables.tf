#General
variable "tags" {
  description = "Tags"
  type        = map(string)
}

#VPC
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


#Instances
variable "ec2_bastion_spects" {
  description = "EC2 specifications"
  type = object({
    ami           = string
    instance_type = string
  })
}
variable "ec2_database_spects" {
  description = "EC2 specifications"
  type = object({
    ami           = string
    instance_type = string
  })
}

variable "ec2_database_instances" {
  type = map(object({
    name              = string
    user_data_script  = string
    sg_key            = string
  }))

}

#SG
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




