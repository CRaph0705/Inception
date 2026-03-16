#!/bin/bash
set -e

# Check if the database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing the database..."
    mysqld --initialize-insecure --user=mysql
fi

# Start MariaDB in the background for initialization
mysqld_safe --skip-networking &

# Wait for the server to start
echo "Waiting for MariaDB to start..."
while ! mysqladmin ping --silent; do
    sleep 1
done

# Create the database and user
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

echo "DB OK..."
# Temporary shutdown of the server
mysqladmin -u root shutdown

# Final server start in the foreground (Docker waits for this PID)
exec mysqld_safe