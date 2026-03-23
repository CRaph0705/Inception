FROM debian:bookworm

RUN apt update && apt install -y php-cli php-mysqli curl && apt clean

RUN mkdir -p /var/www/html

RUN curl -L https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php -o /var/www/html/index.php

RUN chown -R root:root /var/www/html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]