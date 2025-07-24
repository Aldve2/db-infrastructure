
#Security Group for bastion host
resource "aws_security_group" "bastion" {
  name        = "sg_bastion_host"
  description = "Allow SSH external IP access"
  vpc_id      = var.vpc_id

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_bastion_host"
  }
}

#Security Group for databases instances
# resource "aws_security_group" "sg_databases_instances" {
#   for_each    = var.sg_names
#   name        = each.value
#   description = "Allow Bastion to access databases"
#   vpc_id      = var.vpc_id



#   ingress {
#     description     = "Allow ICMP ping from bastion"
#     from_port       = -1
#     to_port         = -1
#     protocol        = "icmp"
#     security_groups = [aws_security_group.bastion.id]
#   }
#   ingress {
#     description     = "Allow SSH from Bastion"
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.bastion.id]
#   }


#   dynamic "ingress" {
#     for_each = [
#       for port in lookup(var.ingress_port_list_databases, each.key, []) : {
#         port = port
#       }
#     ]
#     content {
#       description     = "Access for ${each.key} from Bastion"
#       from_port       = ingress.value.port
#       to_port         = ingress.value.port
#       protocol        = "tcp"
#       security_groups = [aws_security_group.bastion.id]
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "sg_databases"
#   }
# }

#Security Group for databases instances
resource "aws_security_group" "sg_databases_instances" {
  for_each    = var.security_groups
  name        = each.value.name
  description = "Allow Bastion to access databases"
  vpc_id      = var.vpc_id



  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = {
    Name = try(each.value.name, each.key)
  }
}
