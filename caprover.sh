#!/bin/sh

# Author : Asif Chowdhury
# Copyright (c) asifthewebguy.me

# This script is used to install Caprover on ubuntu server
# requires docker and docker-compose to be installed
# requires root access to create override file

# get ip address as variable from user input
# read -p "Enter your server's IP address: " IP_ADDRESS
# echo -n "Your server's IP address is:"
# read IP_ADDRESS
# if input is empty, set 192.168.0.205 as default
# if [ -z "$IP_ADDRESS" ]; then
#     IP_ADDRESS="192.168.0.205"
# fi
# get device ip address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# print ip address
echo "Your server's IP address is: $IP_ADDRESS"

# if ip address is private ip, set configure override
if [[ $IP_ADDRESS =~ ^192\.168\.0\.[0-9]{1,3}$ ]]; then
    CONFIGURE_OVERRIDE="true"
else
    CONFIGURE_OVERRIDE="false"
fi

# check if docker is installed
# if not, install docker

if ! [ -x "$(command -v docker)" ]; then
    echo 'Error: docker is not installed.'
    # echo 'Please install docker and run this script again.'
    # echo 'To install docker, run this command: wget -O - https://raw.githubusercontent.com/asifthewebguy/ubuntu-server-setup/master/docker.sh | bash'

    # ask user if they want to install docker
    echo "Do you want to install docker? [y/n]"
    read INSTALL_DOCKER
    # if user input is y, install docker
    if [ "$INSTALL_DOCKER" == "y" ]; then
        # install docker
        wget -O - https://raw.githubusercontent.com/asifthewebguy/shellscripts/main/docker.sh
    else
        echo "Please install docker and run this script again."
        exit 1
    fi
    exit 1
fi

# if configure override is true, then scip domain verification and install caprover with private ip address
if [ "$CONFIGURE_OVERRIDE" = "true" ]; then
    # setting up override
    sudo mkdir /captain && sudo mkdir /captain/data/ && sudo touch /captain/data/config-override.json
    # adding override to config-override.json
    echo  "{\"skipVerifyingDomains\":\"true\"}" >  /captain/data/config-override.json
    # installing caprover
    docker run -e MAIN_NODE_IP_ADDRESS=$IP_ADDRESS -p 80:80 -p 443:443 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover
else
    # installing caprover
    docker run -p 80:80 -p 443:443 -p 3000:3000 -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover
fi

# check if caprover is installed
