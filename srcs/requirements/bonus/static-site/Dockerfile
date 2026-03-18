FROM debian:bookworm

RUN apt update && apt install -y nginx

COPY ./website /var/www/html

CMD [ "nginx", "-g", "daemon off;" ]