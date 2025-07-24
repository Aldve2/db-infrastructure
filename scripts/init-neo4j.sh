#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker

mkdir -p /volumeDB/neo4j/data
mkdir -p /volumeDB/neo4j/import

docker network create accrual_network

docker run -d \
  --name neo4j \
  --network accrual_network \
  -p 7474:7474 \
  -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/6154277353 \
  -e NEO4J_initial_dbms_default__database=railway \
  -e NEO4J_PLUGINS='["apoc", "apoc-extended"]' \
  -e NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
  -e NEO4J_apoc_export_file_enabled=true \
  -e NEO4J_apoc_import_file_enabled=true \
  -e NEO4J_apoc_import_file_use_neo4j_config=true \
  -v /volumeDB/neo4j/data:/data \
  -v /volumeDB/neo4j/import:/var/lib/neo4j/import \
  neo4j:latest