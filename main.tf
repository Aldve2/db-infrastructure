terraform { 
  cloud { 
    
    organization = "crm-project" 

    workspaces { 
      name = "db-infrastructure" 
    } 
  } 
}

module "vpc_crm" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "instance_sg" {
  source          = "./modules/security_groups"
  vpc_id          = module.vpc_crm.vpc_id
  vpc_cidr        = module.vpc_crm.vpc_cidr
  security_groups = var.security_groups
}

resource "aws_instance" "bastion_host" {
  ami                         = var.ec2_bastion_spects.ami
  instance_type               = var.ec2_bastion_spects.instance_type
  key_name                    = data.aws_key_pair.key.key_name
  subnet_id                   = module.vpc_crm.public_subnet_ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.instance_sg.bastion_sg_id]
  tags = {
    Name = "bastion-host"
  }
}

# resource "aws_instance" "ec2_database_instance" {
#   for_each                    = var.database_instances
#   ami                         = var.ec2_database_spects.ami
#   instance_type               = var.ec2_database_spects.instance_type
#   subnet_id                   = module.vpc_crm.private_subnet_ids[0]
#   key_name                    = data.aws_key_pair.key.key_name
#   associate_public_ip_address = false
#   vpc_security_group_ids = [
#     module.instance_sg.bastion_sg_id,
#     module.instance_sg.databases_instances_id[each.value.sg_key]
#   ]
#   user_data = file("${path.module}/${each.value.user_data}")
#   tags = {
#     "Name" = "${each.value.name}"
#   }
# }


# resource "aws_instance" "ec2_database_instance" {
#   for_each                    = var.ec2_database_instances
#   ami                         = var.ec2_database_spects.ami
#   instance_type               = var.ec2_database_spects.instance_type
#   subnet_id                   = module.vpc_crm.private_subnet_ids[0]
#   key_name                    = data.aws_key_pair.key.key_name
#   associate_public_ip_address = false
#   user_data                   = file("${path.module}/scripts/${each.value.user_data_script}")

#   vpc_security_group_ids = [
#     module.instance_sg.security_group_ids[each.value.sg_key]
#   ]

#   tags = {
#     Name = each.value.name
#   }
# }

resource "aws_instance" "mongo_database" {
  ami                         = var.ec2_database_spects.ami
  instance_type               = var.ec2_database_spects.instance_type
  subnet_id                   = module.vpc_crm.public_subnet_ids[0]
  key_name                    = data.aws_key_pair.key.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/init-mongo.sh")

  vpc_security_group_ids = [
    module.instance_sg.mongo_sg_id
  ]

  tags = {
    Name = "mongo-db"
  }
}

resource "aws_instance" "redis_database" {
  ami                         = var.ec2_database_spects.ami
  instance_type               = var.ec2_database_spects.instance_type
  subnet_id                   = module.vpc_crm.public_subnet_ids[0]
  key_name                    = data.aws_key_pair.key.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/init-redis.sh")

  vpc_security_group_ids = [
    module.instance_sg.redis_sg_id
  ]

  tags = {
    Name = "redis-db"
  }
}

resource "aws_instance" "neo4j_database" {
  ami                         = var.ec2_database_spects.ami
  instance_type               = var.ec2_database_spects.instance_type
  subnet_id                   = module.vpc_crm.public_subnet_ids[0]
  key_name                    = data.aws_key_pair.key.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/init-neo4j.sh")

  vpc_security_group_ids = [
    module.instance_sg.neo4j_sg_id
  ]

  tags = {
    Name = "neo4j-db"
  }
}


resource "aws_instance" "cassandra_database" {
  ami                         = var.ec2_database_spects.ami
  instance_type               = var.ec2_database_spects.instance_type
  subnet_id                   = module.vpc_crm.public_subnet_ids[0]
  key_name                    = data.aws_key_pair.key.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/init-cassandra.sh")

  vpc_security_group_ids = [
    module.instance_sg.cassandra_sg_id
  ]

  tags = {
    Name = "cassandra-db"
  }
}

# resource "aws_instance" "kafka-db" {
#   ami                         = var.ec2_database_spects.ami
#   instance_type               = var.ec2_database_spects.instance_type
#   subnet_id                   = module.vpc_crm.public_subnet_ids[0]
#   key_name                    = data.aws_key_pair.key.key_name
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [module.instance_sg.bastion_sg_id]


#   tags = {
#     Name = "kafka-db"
#   }

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("/crm_keys_test.pem")
#     host        = self.public_ip
#   }

#   provisioner "file" {
#     source      = "${path.module}/scripts/init-kafka.sh"
#     destination = "/home/ubuntu/init-kafka.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /home/ubuntu/init-kafka.sh",
#       "sudo -E /home/ubuntu/init-kafka.sh ${self.public_ip}"
#     ]
#   }
# }
# Repositorio ECR para person-service
# resource "aws_ecr_repository" "person" {
#   name = "person-service"
# }
