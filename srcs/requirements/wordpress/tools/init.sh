#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

echo "waiting MariaDB"

until mysqladmin ping --silent --socket=/var/lib/mysql/mysql.sock; do
    sleep 1
done

echo "MariaDB OK"

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f wp-config.php ]; then

    wp core download --allow-root

    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root

    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

fi

exec php-fpm -F
