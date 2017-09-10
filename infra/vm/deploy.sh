#!/bin/bash
ls
pwd

sudo docker-compose  up -d 
sudo docker-compose scale node-app=5
