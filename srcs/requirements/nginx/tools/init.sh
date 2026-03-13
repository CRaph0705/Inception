#!/bin/bash

set -e

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=student/CN=rcochran.42.fr"

chmod 755 /var/www/html

chown -R www-data:www-data /var/www/html

exec nginx -g "daemon off;" #-g lance en premier plan >> le container ne se stop pas
