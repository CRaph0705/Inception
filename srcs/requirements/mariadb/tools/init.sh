#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "Initializing MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    mysqld_safe --datadir=/var/lib/mysql &

    until mysqladmin ping --silent; do
        sleep 1
    done

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
chown -R mysql:mysql /var/lib/mysql
exec mysqld_safe --datadir=/var/lib/mysql
