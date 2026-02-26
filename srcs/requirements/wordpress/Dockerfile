FROM debian:bookworm

RUN apt update && \
        apt install -y \
        php-fpm \
        php-mysql \
        curl \
        mariadb-client && \
        apt clean && \
        rm -rf /var/lib/apt/lists/*

# ^ évite de modifier une ligne commentée
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        && chmod +x wp-cli.phar \
        && mv wp-cli.phar /usr/local/bin/wp


COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

ENTRYPOINT ["/init.sh"]
