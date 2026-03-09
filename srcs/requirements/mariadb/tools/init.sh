#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "Initializing MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    mysqld_safe --user=mysql --datadir=/var/lib/mysql &

    until mysqladmin ping --silent --socket=/var/lib/mysql/mysql.sock; do
        sleep 1
    done

    mysql -u root -S /var/lib/mysql/mysql.sock << EOF
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
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} -S /var/lib/mysql/mysql.sock shutdown
fi

chown -R mysql:mysql /var/lib/mysql
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0