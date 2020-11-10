#! /bin/bash

#start express api
forever start /app/nodejs/nginxdockerapi.js

#start nginx
/usr/local/nginx/sbin/nginx