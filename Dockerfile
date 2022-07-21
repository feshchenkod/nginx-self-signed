FROM nginx:alpine

LABEL org.opencontainers.image.source https://github.com/feshchenkod/nginx-self-signed

RUN apk add --no-cache openssl

COPY proxy.conf /etc/nginx/templates/default.conf.template
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN chmod +x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]