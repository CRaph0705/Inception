FROM debian:bookworm

# Install MariaDB and OpenSSL
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create necessary folders
RUN mkdir -p /run/mysqld /etc/mysql/certs \
    && chown mysql:mysql /run/mysqld

# Copy MariaDB configuration
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy TLS-ready initialization script
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/init.sh"]