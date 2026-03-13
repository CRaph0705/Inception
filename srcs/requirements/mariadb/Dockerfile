FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server mariadb-client && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306

CMD ["mysqld"]