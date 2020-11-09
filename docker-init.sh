#! /bin/bash

# Copy files
cp /home/nginx/nginx/nginxvmapi.ts /home/nginx/nodejs
cp /home/nginx/nginx/nginxdockerapi.ts /home/nginx/nodejs
cp /home/nginx/nginx/nginxvmapi.service /lib/systemd/system

# Compile VM's api
cd /home/nginx/nodejs && tsc /home/nginx/nodejs/nginxvmapi.ts
cd /home/nginx/nodejs && tsc /home/nginx/nodejs/nginxdockerapi.ts

cp /home/nginx/nodejs/nginxdockerapi.js /home/nginx/nginx/nginxdockerapi.js 

# Build nginx docker image
docker build -t nginx_forward_proxy:latest /home/nginx/nginx

#Run api service
systemctl start nginxvmapi