tags = {
  "env"         = "PROD"
  "owner"       = "Dav"
  "cloud"       = "aws"
  "IAC"         = "Terraform"
  "IAC_Version" = "1.11.3"
  "project"     = "CRM"
}

#VPC
vpc_cidr = "10.0.0.0/16"

azs = ["us-east-1a", "us-east-1b"]

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.101.0/24",
  "10.0.102.0/24"
]

#Bastion
ec2_bastion_spects = {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.small"
}

#databases
ec2_database_spects = {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.medium"
}


#Databases SG
security_groups = {
  kafka = {
    name          = "sg_kafka"
    description = "SG for Kafka"
    ingress_rules = [
      {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
      },
      {
        description = "Kafka Port 10091"
        from_port   = 10091
        to_port     = 10091
        protocol    = "tcp"
      },
      {
        description = "Kafka Port 10094"
        from_port   = 10094
        to_port     = 10094
        protocol    = "tcp"
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  mongo = {
    name          = "sg_mongo"
    description = "SG for Mongo"
    ingress_rules = [
      {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
      },
      {
        description = "MongoDB Port"
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  redis = {
    name          = "sg_redis"
    description = "SG for Redis"
    ingress_rules = [
      {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
      },
      {
        description = "Redis Port"
        from_port   = 6379
        to_port     = 6379
        protocol    = "tcp"
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  neo4j = {
    name          = "sg_neo4j"
    description = "SG for neoj"
    ingress_rules = [
      {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
      },
      {
        description = "Neo4j Port"
        from_port   = 7474
        to_port     = 7474
        protocol    = "tcp"
      },
      {
        description = "Neo4j Port"
        from_port   = 7687
        to_port     = 7687
        protocol    = "tcp"
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  cassandra = {
    name          = "sg_cassandra"
    description = "SG for cassandra"
    ingress_rules = [
      {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
      },
      {
        description = "cassandra Port"
        from_port   = 9042
        to_port     = 9042
        protocol    = "tcp"
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

ec2_database_instances = {
  kafka = {
    name             = "kafka-db"
    user_data_script = "init-kafka.sh"
    sg_key           = "kafka"
    
  }
  mongo = {
    name             = "mongo-db"
    user_data_script = "init-mongo.sh"
    sg_key           = "mongo"
  }
  redis = {
    name             = "redis-db"
    user_data_script = "init-redis.sh"
    sg_key           = "redis"
  }
  neo4j = {
    name             = "neo4j-db"
    user_data_script = "init-neo4j.sh"
    sg_key           = "neo4j"
  }
  cassandra = {
    name             = "cassandra-db"
    user_data_script = "init-cassandra.sh"
    sg_key           = "cassandra"
  }
}

