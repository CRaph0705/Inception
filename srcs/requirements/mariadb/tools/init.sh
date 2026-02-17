#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "Initializing MariaDB..."

    mysqld --initialize-insecure --user=mysql
    mysqld_safe &

    sleep 5

    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

fi

exec mysqld_safe
