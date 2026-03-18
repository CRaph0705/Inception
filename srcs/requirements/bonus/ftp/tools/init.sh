#!/bin/bash
set -e  # Exit the script if any command fails

# Create the FTP user if it doesn't already exist
if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

mkdir -p /var/www/wordpress/wp-content/uploads
chown -R "$FTP_USER:$FTP_USER" /var/www/wordpress/wp-content/uploads
chmod -R 755 /var/www/wordpress/wp-content/uploads

mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty


# Run vsftpd in the foreground
exec /usr/sbin/vsftpd /etc/vsftpd.conf