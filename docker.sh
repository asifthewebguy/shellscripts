#!/bin/sh

# Author : Asif Chowdhury
# Copyright (c) asifthewebguy.me

# This script is used to install docker on ubuntu server
# requires root access

# removing old docker versions
sudo apt remove docker docker-engine docker.io containerd runc

# updating apt
sudo apt update

# installing packages to allow apt to use a repository over HTTPS
sudo apt install ca-certificates curl gnupg lsb-release

# adding docker's official GPG key
sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# setting up the stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# updating apt and installing docker
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# adding user to docker group
sudo usermod -aG docker $USER && newgrp docker

# enabling docker service
sudo systemctl enable docker and sudo systemctl restart docker

# get docker version as variable
DOCKER_VERSION=$(docker --version)
docker --version

# checking docker-compose version
DOCKER_COMPOSE_VERSION=$(docker-compose --version)
docker-compose --version

# print info about docker installation
echo "Docker version: $DOCKER_VERSION"
echo "Docker compose version: $DOCKER_COMPOSE_VERSION"
echo "Docker installed successfully"
