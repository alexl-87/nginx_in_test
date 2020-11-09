#! /bin/bash

# Build nginx docker image
docker build -t nginx_forward_proxy:latest /home/nginx/nginx

# Compile VM's api
tsc /home/nginx/nginx/nginx_api.ts

# Copy files and run api service
cp /home/nginx/nginx/nginx_api.js /home/nginx/nodejs
cp /home/nginx/nginx/nginx_api.service /lib/systemd/system
systemctl start nginx_api

