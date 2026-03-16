#!/bin/bash
set -e

SSL_DIR="/etc/nginx/ssl"
KEY_FILE="$SSL_DIR/inception.key"
CRT_FILE="$SSL_DIR/inception.crt"

# Create the SSL folder if necessary
mkdir -p "$SSL_DIR"

# Generate the certificate only if it doesn't exist
if [ ! -f "$KEY_FILE" ] || [ ! -f "$CRT_FILE" ]; then
    echo "No SSL certificate found. Generating self-signed certificate..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CRT_FILE" \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=student/CN=rcochran.42.fr"
    echo "Certificate generated."
else
    echo "SSL certificate already exists. Skipping generation."
fi

# Fix permissions for the web root
mkdir -p /var/www/html
chmod 755 /var/www/html
chown -R www-data:www-data /var/www/html

# Start Nginx in the foreground
exec nginx -g "daemon off;"  # -g launches Nginx in the foreground so the container keeps running