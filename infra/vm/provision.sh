#!/bin/bash

apt-get update -y || sudo apt-get update -y || true

apt-get install -y sudo  || true

echo ':::install curl:::'
sudo apt-get install curl -y

echo ':::install python3 and pip:::'
sudo apt-get install -y python3
sudo apt-get install -y python3-setuptools
sudo easy_install3 pip

echo ':::install git:::'
sudo apt-get install -y git

echo ':::install docker:::'
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
    
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 
 sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
sudo apt-get update -y
sudo apt-get install -y docker-ce

echo ':::install docker compose:::'
sudo pip3 install --upgrade pip3
sudo pip3 install docker-compose

echo ':::install awscli:::'
sudo pip3 install --upgrade awscli

echo ':::install nodejs 8.x:::'
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

echo '::: clean up :::'
sudo apt-get autoremove -y
