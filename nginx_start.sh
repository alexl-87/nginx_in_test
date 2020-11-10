#! /bin/bash

#start nginx
/usr/local/nginx/sbin/nginx

#start express api
forever start /app/nodejs/nginxdockerapi.js