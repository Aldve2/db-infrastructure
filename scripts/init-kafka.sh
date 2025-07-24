#!/bin/bash
apt update -y
apt upgrade -y
apt install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

mkdir -p /opt/kafka
IP_TEST="$1"
cd /opt/kafka

docker network create kafka-server || true

cat >docker-compose.yml <<EOL
version: '3.8'

networks:
  kafka-server:
    external:
      name: kafka-server

services:
  kafka:
    image: bitnami/kafka:latest
    container_name: kafka
    ports:
      - "10092:10092"
      - "10093:10093"
      - "10094:10094"
    environment:
      KAFKA_CFG_NODE_ID: 0
      KAFKA_CFG_PROCESS_ROLES: controller,broker
      KAFKA_CFG_AUTO_CREATE_TOPICS_ENABLE: "true"
      KAFKA_CFG_LISTENERS: PLAINTEXT://:10092,CONTROLLER://:10093,EXTERNAL://:10094
      KAFKA_CFG_ADVERTISED_LISTENERS: PLAINTEXT://kafka:10092,EXTERNAL://$IP_TEST:10094
      KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,EXTERNAL:PLAINTEXT,PLAINTEXT:PLAINTEXT
      KAFKA_CFG_CONTROLLER_QUORUM_VOTERS: 0@kafka:10093
      KAFKA_CFG_CONTROLLER_LISTENER_NAMES: CONTROLLER
    networks:
      - kafka-server
  kafdrop:
    depends_on:
      - kafka
    image: obsidiandynamics/kafdrop:latest
    container_name: kafdrop
    ports:
      - "10091:10091"
    environment:
      SERVER_PORT: 10091
      KAFKA_BROKERCONNECT: kafka:10092
    networks:
      - kafka-server
EOL

docker-compose up -d
sleep 20 && docker restart kafdrop
echo "Kafka is ready - IP: ${IP_TEST}"