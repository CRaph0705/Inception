#!/bin/bash
set -e  # Exit immediately if any command fails

UPLOAD_DIR="/var/www/wordpress/wp-content/uploads"

# Prepare uploads folder
mkdir -p $UPLOAD_DIR

# Create FTP user if missing
if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    echo $FTP_USER >> /etc/vsftpd.userlist
fi

usermod -aG www-data $FTP_USER

# Set ownership and permissions for FTP user
chown -R www-data:www-data $UPLOAD_DIR
chmod -R 2775 $UPLOAD_DIR
#chmod g+s $UPLOAD_DIR

echo "ftp folder created"
mkdir -p $UPLOAD_DIR/ftp
echo "permissions given"
chown $FTP_USER:www-data $UPLOAD_DIR/ftp
chmod 2775 $UPLOAD_DIR/ftp
#local_root=$UPLOAD_DIR/ftp


# Prepare vsftpd runtime folder
mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

# Create log folder and file for Fail2ban
mkdir -p /var/log/vsftpd
touch /var/log/vsftpd/xferlog
chmod 644 /var/log/vsftpd/xferlog

# Start vsftpd in foreground
exec /usr/sbin/vsftpd /etc/vsftpd.conf