FROM debian:bullseye

RUN apt update && apt install -y nginx openssl

COPY tools/init.sh /init.sh
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /init.sh

EXPOSE 443

ENTRYPOINT ["/init.sh"]

