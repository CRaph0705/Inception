#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

echo "waiting MariaDB"

while ! mysqladmin ping -h mariadb --silent; do
    sleep 1
done

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f wp-config.php ]; then

    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    mv wordpress/* .
    rm -rf wordpress latest.tar.gz

    chown -R www-data:www-data /var/www/html # Set ownership to www-data for WordPress files to ensure proper permissions.

    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

exec php-fpm -F
