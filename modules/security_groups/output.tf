output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "security_group_ids" {
  description = "IDs for security groups"
  value = {
    for name, sg in aws_security_group.sg_databases_instances :
    name => sg.id
  }
}

output "kafka_sg_id" {
  value = aws_security_group.sg_databases_instances["kafka"].id
}

output "mongo_sg_id" {
  value = aws_security_group.sg_databases_instances["mongo"].id
}
output "redis_sg_id" {
  value = aws_security_group.sg_databases_instances["redis"].id
}
output "neo4j_sg_id" {
  value = aws_security_group.sg_databases_instances["neo4j"].id
}
output "cassandra_sg_id" {
  value = aws_security_group.sg_databases_instances["cassandra"].id
}

output "security_group_names" {
  description = "Names for security groups"
  value = {
    for name, sg in aws_security_group.sg_databases_instances :
    name => sg.name
  }
}