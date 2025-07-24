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
  redis:
    image: redis:latest
    restart: always
    ports:
      - "6379:6379"
    volumes:
      - ./volumeDB/redis/data:/data
    command: [ "redis-server", "--protected-mode", "no" ]

EOL
docker-compose up -d
echo "Mongo is ready"