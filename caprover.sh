#!/bin/sh

# Author : Asif Chowdhury
# Copyright (c) asifthewebguy.me

# This script is used to install Caprover on ubuntu server
# requires docker and docker-compose to be installed
# requires root access to create override file

# get ip address as variable from user input
read -n -p "Enter your server's IP address: " IP_ADDRESS
# echo "Your server's IP address is:"
# read IP_ADDRESS
# if input is empty, set 192.168.0.205 as default
if [ -z "$IP_ADDRESS" ]; then
    IP_ADDRESS="192.168.0.205"
fi

# if ip address is private ip, set configure override
if [[ $IP_ADDRESS =~ ^192\.168\.0\.[0-9]{1,3}$ ]]; then
    CONFIGURE_OVERRIDE="true"
else
    CONFIGURE_OVERRIDE="false"
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
