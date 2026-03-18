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

# Additional user
SECOND_USER="editoruser"
SECOND_EMAIL="editor@example.com"
SECOND_PASSWORD="editorpassword"

echo "Waiting for MariaDB on $DB_HOST..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; do
    sleep 1
done
echo "MariaDB is ready!"

# Install WordPress if not installed
if [ ! -f "$WP_DIR/wp-config.php" ]; then
    echo "Installing WordPress..."
    if [ -z "$(ls -A $WP_DIR)" ]; then
        wp core download --path="$WP_DIR" --locale=fr_FR --allow-root
    else
        echo "WordPress files already exist, skipping download"
    fi
    # Create wp-config.php
    wp config create --path="$WP_DIR" \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root

    # Add Redis configuration if not already present
    REDIS_HOST=${WP_REDIS_HOST:-redis}   # fallback 'redis'
    REDIS_PORT=${WP_REDIS_PORT:-6379}    # fallback 6379
    REDIS_CONFIG_FILE="$WP_DIR/wp-config.php"

    grep -q "WP_REDIS_HOST" "$REDIS_CONFIG_FILE" || sed -i "/^\/\* That's all, stop editing!/i define('WP_REDIS_HOST', '$REDIS_HOST');" "$REDIS_CONFIG_FILE"
    grep -q "WP_REDIS_PORT" "$REDIS_CONFIG_FILE" || sed -i "/^\/\* That's all, stop editing!/i define('WP_REDIS_PORT', $REDIS_PORT);" "$REDIS_CONFIG_FILE"
    # Install WordPress core
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

# Ensure www-data owns everything
chown -R www-data:www-data "$WP_DIR"
# Allow FTP user to write to uploads
chown -R www-data:$FTP_USER /var/www/wordpress/wp-content/uploads
chmod -R 775 /var/www/wordpress/wp-content/uploads

# Create admin user if it doesn't exist
if ! wp user get "$WP_ADMIN_USER" --allow-root --path="$WP_DIR" &> /dev/null; then
    wp user create "$WP_ADMIN_USER" "$WP_ADMIN_EMAIL" \
        --role=administrator \
        --user_pass="$WP_ADMIN_PASSWORD" \
        --allow-root \
        --path="$WP_DIR"
    echo "Administrator '$WP_ADMIN_USER' created."
else
    echo "Administrator '$WP_ADMIN_USER' already exists."
fi

# Create a second user if it doesn't exist
if ! wp user get "$SECOND_USER" --allow-root --path="$WP_DIR" &> /dev/null; then
    wp user create "$SECOND_USER" "$SECOND_EMAIL" \
        --role=editor \
        --user_pass="$SECOND_PASSWORD" \
        --allow-root \
        --path="$WP_DIR"
    echo "Editor '$SECOND_USER' created."
else
    echo "Editor '$SECOND_USER' already exists."
fi

# Install Redis extension via WP-CLI
wp plugin install redis-cache --activate --allow-root --path="$WP_DIR"


# Run PHP-FPM in the foreground
php-fpm8.2 -F