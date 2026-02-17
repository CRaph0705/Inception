FROM debian:bullseye

RUN apt update && apt install -y php-fpm php-mysql curl

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

ENTRYPOINT ["/init.sh"]

# CMD ["php-fpm7.4", "-F"]
