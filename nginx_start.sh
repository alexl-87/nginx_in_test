#! /bin/bash

#start nginx
/usr/local/nginx/sbin/nginx

#start express api
cd /app/nodejs && forever start nginxdockerapi.js