#!/bin/bash
set -e

echo "[WordPress] Waiting for MariaDB to be ready..."

until mysqladmin ping -h "$WORDPRESS_DB_HOST" --silent; do
    echo "[WordPress] MariaDB is not ready yet. Sleeping 2s..."
    sleep 2
done

echo "[WordPress] MariaDB is ready!"

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "[WordPress] Downloading WordPress core..."
    wp core download --allow-root

    echo "[WordPress] Creating wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root

    echo "[WordPress] Installing WordPress..."
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "[WordPress] Installation complete!"
else
    echo "[WordPress] wp-config.php already exists. Skipping installation."
fi

mkdir -p /run/php

exec php-fpm -F