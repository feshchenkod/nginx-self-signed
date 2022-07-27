#!/bin/sh
set -x
export CERTPATH="/etc/ssl/nginx.crt"
export KEYPATH="/etc/ssl/nginx.key"

if [ ! -f ${CERTPATH} ]; then
    cd /etc/ssl/
    openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout nginx.key -out nginx.crt -subj "/C=US/ST=Action/L=Dev/O=Dev/CN=${SERVERNAME}"
fi

if [ ! -z "${FULLCHAIN_PEM}" ]; then
    echo "${FULLCHAIN_PEM}" > /etc/ssl/fullchain.pem
    echo "${KEY_PEM}" > /etc/ssl/key.pem
    export CERTPATH="/etc/ssl/fullchain.pem"
    export KEYPATH="/etc/ssl/key.pem"
fi

envsubst '$SERVERNAME;$UPSTREAM;$CERTPATH;$KEYPATH' <  /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'