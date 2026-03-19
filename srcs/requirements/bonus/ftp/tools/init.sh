#!/bin/bash
set -e  # Exit immediately if any command fails

# Create FTP user if missing
if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

# Prepare uploads folder
mkdir -p /var/www/wordpress/wp-content/uploads

# Set ownership and permissions for FTP user
chown -R "$FTP_USER:$FTP_USER" /var/www/wordpress/wp-content/uploads
chmod -R 775 /var/www/wordpress/wp-content/uploads  # owner+group can write

# Set group sticky bit so new files inherit the group >> avoid permissions issues later
chmod g+s /var/www/wordpress/wp-content/uploads

# Prepare vsftpd runtime folder
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

# Start vsftpd in foreground
exec /usr/sbin/vsftpd /etc/vsftpd.conf