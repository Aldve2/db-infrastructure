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
  mongo:
    image: mongo:latest
    restart: always
    ports:
      - "27017:27017"
    volumes:
      - ./volumeDB/mongoDB/data:/data/db
    environment:
      MONGO_INITDB_DATABASE: projectManagement
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin123

EOL
docker-compose up -d
echo "Mongo is ready"