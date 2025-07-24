#!/bin/bash
apt update -y
apt upgrade -y
apt install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
cat >docker-compose.yml <<EOL
version: '3.8'

services:
  cassandra:
    image: cassandra:latest
    container_name: cassandra
    ports:
      - "9042:9042"  # Puerto CQL (para aplicaciones)
      - "7000:7000"  # Puerto de comunicación entre nodos
      - "7199:7199"  # Puerto JMX (monitoreo)
    environment:
      CASSANDRA_CLUSTER_NAME: "LogCluster"
      CASSANDRA_DC: "dc1"
      CASSANDRA_RACK: "rack1"
      CASSANDRA_ENDPOINT_SNITCH: "GossipingPropertyFileSnitch"
      CASSANDRA_NUM_TOKENS: "32"
      CASSANDRA_START_RPC: "true"
      HEAP_NEWSIZE: "512M"
      MAX_HEAP_SIZE: "2048M"
    volumes:
      - cassandra_data:/var/lib/cassandra
    healthcheck:
      test: ["CMD-SHELL", "nodetool status | grep UN"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: unless-stopped

volumes:
  cassandra_data:

EOL
docker-compose up -d
echo "Cassandra is ready"