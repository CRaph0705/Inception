#!/bin/bash
set -e

# Environment variables
WP_DIR=/var/www/wordpress

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

REDIS_HOST=${WP_REDIS_HOST:-redis}  # default 'redis' service
REDIS_PORT=${WP_REDIS_PORT:-6379}   # default port 6379


# Create the folder if necessary and set permissions
mkdir -p "$WP_DIR"
chown -R www-data:www-data "$WP_DIR"


echo "Waiting for MariaDB on $DB_HOST..."
until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; do
    sleep 1
done
echo "MariaDB is ready!"

# Install WordPress if not installed
if ! wp core is-installed --allow-root --path="$WP_DIR"; then
    echo "Installing WordPress."

    wp core download --path="$WP_DIR" --locale=fr_FR --allow-root

    # Create wp-config.php
    wp config create --path="$WP_DIR" \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --allow-root

    # Add Redis configuration if not already present
    WP_CONFIG_FILE="$WP_DIR/wp-config.php"
    grep -q "WP_REDIS_HOST" "$WP_CONFIG_FILE" || \
        sed -i "/^\/\* That's all, stop editing!/i define('WP_REDIS_HOST', '$REDIS_HOST');" "$WP_CONFIG_FILE"
    grep -q "WP_REDIS_PORT" "$WP_CONFIG_FILE" || \
        sed -i "/^\/\* That's all, stop editing!/i define('WP_REDIS_PORT', $REDIS_PORT);" "$WP_CONFIG_FILE"

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
    echo "WordPress is already installed."
fi

# Ensure www-data owns everything
chown -R www-data:www-data "$WP_DIR"

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

# Create .htaccess with correct MIME type for CSS if it doesn't exist
HTACCESS_FILE="$WP_DIR/.htaccess"

if [ ! -f "$HTACCESS_FILE" ]; then
    echo "Creating .htaccess with WordPress rules and CSS MIME fix..."
    cat <<'EOF' > "$HTACCESS_FILE"
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress

# Force correct MIME type for CSS
<IfModule mod_mime.c>
    AddType text/css .css
</IfModule>

# Force correct MIME type for JS
<IfModule mod_mime.c>
    AddType application/javascript .js
</IfModule>
EOF
    chown www-data:www-data "$HTACCESS_FILE"
    echo ".htaccess created at $HTACCESS_FILE"
else
    echo ".htaccess already exists, skipping creation."
fi

# Run PHP-FPM in the foreground
php-fpm8.2 -F