#!/bin/sh
set -x
CERT_PATH=/etc/ssl/nginx.crt
KEY_PATH=/etc/ssl/nginx.key

if [ [ ! -z "${FULLCHAIN_PEM}" ] && [ ! -z "${KEY_PEM}" ] ]; then
    echo ${FULLCHAIN_PEM} > /etc/ssl/fullchain.pem
    echo ${KEY_PEM} > /etc/ssl/key.pem
    CERT_PATH=/etc/ssl/fullchain.pem
    KEY_PATH=/etc/ssl/key.pem
else
    cd /etc/ssl/
    openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout nginx.key -out nginx.crt -subj "/C=US/ST=Action/L=Dev/O=Dev/CN=${SERVERNAME}"
fi

envsubst '$SERVERNAME;$UPSTREAM;$CERT_PATH;$KEY_PATH' <  /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'