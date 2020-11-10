FROM        ubuntu:20.10
MAINTAINER  Alexander Latyshev <latyshevmb@gmail.com>

WORKDIR /app

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y gcc g++ make gawk perl curl wget libssl-dev openssl git vim

# Download sources:
RUN cd /app && wget \
    https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz \
    http://zlib.net/zlib-1.2.11.tar.gz \
    https://nginx.org/download/nginx-1.18.0.tar.gz

# Untar sources
RUN for f in *.tar.gz; do tar zxf "$f"; done
RUN rm *.tar.gz

# PCRE – Supports regular expressions. Required by the NGINX Core and Rewrite modules.
RUN cd /app/pcre-8.44 && ./configure && make && make install

# zlib – Supports header compression. Required by the NGINX Gzip module.
RUN cd /app/zlib-1.2.11 && ./configure && make && make install

# Patch NGINX to support ssl forwarding
RUN cd /app/nginx-1.* && \
    git clone https://github.com/chobits/ngx_http_proxy_connect_module && \
    patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch

# Configure and install NGINX
RUN cd /app/nginx-1.* && \
 ./configure \
--with-http_stub_status_module \
--with-http_realip_module \
--with-threads \
--with-http_ssl_module \
--with-stream \
--with-pcre=../pcre-8.44 \
--with-zlib=../zlib-1.2.11 \
--add-module=./ngx_http_proxy_connect_module && \
make && make install

# Copy custom response code configuration file
COPY nginx_conf_response_code /usr/local/nginx/conf/

# Necessary for the successful SSL certificate files create
# 'RANDFILE = $ENV::HOME/.rnd' commented out
COPY openssl.cnf /etc/ssl/openssl.cnf

# create return file for 4XX response codes
RUN cp /usr/local/nginx/html/50x.html /usr/local/nginx/html/40x.html

# Create SSL certificate files
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.com" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# Install nodejs
RUN mkdir /app/nodejs
COPY package.json /app/nodejs

RUN cd /app/nodejs && apt-get install npm -y
RUN cd /app/nodejs && npm install
RUN cd /app/nodejs && npm install express
RUN cd /app/nodejs && npm install forever -g

COPY nginxdockerapi.js /app/nodejs

# startup script will run nginx and api service app
COPY nginx_start.sh /usr/local/nginx/sbin/
RUN  chmod 0700 /usr/local/nginx/sbin/nginx_start.sh

COPY sample.m3u8 /usr/local/nginx/html/
COPY nginx_conf_stale /usr/local/nginx/conf/