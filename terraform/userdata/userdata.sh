#!/bin/bash
sudo apt update -y
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo apt install postgresql-client -y
sudo apt-get install openjdk-8-jdk -y
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo apt -y install nodejs
sudo npm install pm2@latest -g