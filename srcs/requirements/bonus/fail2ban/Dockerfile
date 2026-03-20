FROM debian:bookworm

RUN apt update && apt install -y fail2ban iptables && apt clean

COPY ./conf/jail.local /etc/fail2ban/jail.local

CMD [ "fail2ban-server", "-f" ]