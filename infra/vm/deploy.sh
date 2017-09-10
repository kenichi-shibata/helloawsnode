#!/bin/bash
ls
pwd
cd /home/ubuntu/helloawsnode
sudo docker-compose  up -d 
sudo docker-compose scale node-app=5
