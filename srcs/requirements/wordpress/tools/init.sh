#!/bin/bash
set -e

WP_DIR=/var/www/wordpress

# Create the folder if necessary and set permissions
mkdir -p "$WP_DIR"
chown -R www-data:www-data "$WP_DIR"

# Environment variables
DB_HOST=${WORDPRESS_DB_HOST}
DB_NAME=${WORDPRESS_DB_NAME}
DB_USER=${WORDPRESS_DB_USER}
DB_PASSWORD=${WORDPRESS_DB_PASSWORD}
WP_ADMIN_USER=${WP_ADMIN_USER}
WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD}
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-admin@example.com}
DOMAIN_NAME=${DOMAIN_NAME}

echo "Waiting for MariaDB on $DB_HOST..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; do
    sleep 1
done
echo "MariaDB is ready!"

if [ ! -f "$WP_DIR/wp-config.php" ]; then
    echo "Installing WordPress..."
    if [ -z "$(ls -A $WP_DIR)" ]; then
        wp core download --path="$WP_DIR" --locale=fr_FR --allow-root
    else
        echo "WordPress files already exist, skipping download"
    fi
    wp config create --path="$WP_DIR" \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root
    wp core install --path="$WP_DIR" \
        --url="http://$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
else
    echo "WordPress is already installed, skipping."
fi

# Run PHP-FPM in the foreground
php-fpm8.2 -F