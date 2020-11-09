#! /bin/bash
cp /usr/local/nginx/conf/nginx.conf.401 /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload