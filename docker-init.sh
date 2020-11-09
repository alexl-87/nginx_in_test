#! /bin/bash

# Build nginx docker image
docker build -t nginx_forward_proxy:latest /home/nginx/nginx

# Copy files
cp /home/nginx/nginx/nginx_api.ts /home/nginx/nodejs
cp /home/nginx/nginx/nginx_api.service /lib/systemd/system

# Compile VM's api
cd /home/nginx/nodejs && tsc /home/nginx/nodejs/nginx_api.ts

#Run api service
systemctl start nginx_api

