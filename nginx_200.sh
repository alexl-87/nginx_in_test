#! /bin/bash
cp /usr/local/nginx/conf/nginx_conf_allow /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload