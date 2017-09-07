#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade

# install python3 and pip 
sudo apt-get install -y python3
sudo apt-get install -y python3-setuptools
sudo easy_install3 pip

# install git
sudo apt-get install -y git

# install docker
sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
sudo apt-get update -y

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

# install docker compose
sudo pip3 install --upgrade pip3
sudo pip3 install docker-compose

# install nodejs 8.x
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# clean up 
sudo apt-get autoremove -y
