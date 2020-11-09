#! /bin/bash

# Build nginx docker image
docker build -t nginx_forward_proxy:latest /home/nginx/nginx

# Copy files
cp /home/nginx/nginx/nginxvmapi.ts /home/nginx/nodejs
cp /home/nginx/nginx/nginxvmapi.service /lib/systemd/system

# Compile VM's api
cd /home/nginx/nodejs && tsc /home/nginx/nodejs/nginxvmapi.ts

#Run api service
systemctl start nginxvmapi

