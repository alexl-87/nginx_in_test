#! /bin/bash
cp /usr/local/nginx/conf/nginx.conf.404 /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload