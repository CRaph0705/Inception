#!/bin/bash
set -e

echo "[WordPress] Waiting for MariaDB to be ready..."

# Utiliser l'utilisateur WordPress pour la connexion
until mysqladmin ping -h "${WORDPRESS_DB_HOST}" -u "${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    sleep 1
done

echo "[WordPress] MariaDB is ready!"

WP_DIR=/var/www/html
cd "$WP_DIR"

# Vérifier que WP-CLI est disponible
if ! command -v wp &> /dev/null; then
    echo "[WordPress] WP-CLI not found! Exiting."
    exit 1
fi

# Installer WordPress seulement si wp-config.php n'existe pas
if [ ! -f wp-config.php ]; then
    echo "[WordPress] Downloading WordPress core..."
    wp core download --allow-root --locale=fr_FR

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
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    echo "[WordPress] Installation complete!"
else
    echo "[WordPress] wp-config.php already exists. Skipping installation."
fi

mkdir -p /run/php

exec php-fpm8.2 -F