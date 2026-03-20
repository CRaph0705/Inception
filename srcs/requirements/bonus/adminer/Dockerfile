FROM debian:bookworm

RUN apt update && apt install -y adminer php php-mysqli && apt clean

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "usr/share/adminer"]