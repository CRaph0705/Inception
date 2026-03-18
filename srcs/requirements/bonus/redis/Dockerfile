FROM debian:bookworm

RUN apt update && apt install -y redis-server && apt clean

CMD [ "redis-server", "--protected-mode", "no" ]