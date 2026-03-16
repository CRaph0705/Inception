FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php8.2 php8.2-fpm php8.2-mysql mariadb-client \
    wget unzip curl less sudo openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/wordpress \
    && chown -R www-data:www-data /var/www/wordpress

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

ENTRYPOINT ["/init.sh"]