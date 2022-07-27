#!/bin/sh
set -x

cd /etc/ssl/
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout nginx.key -out nginx.crt -subj "/C=US/ST=Action/L=Dev/O=Dev/CN=${SERVERNAME}"

envsubst '$SERVERNAME;$UPSTREAM;$CERT_PATH;$KEY_PATH' <  /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'