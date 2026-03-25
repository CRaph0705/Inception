FROM debian:bookworm

RUN apt update && apt install -y fail2ban iptables && apt clean

COPY ./conf/jail.local /etc/fail2ban/jail.local
COPY ./conf/filter.d/vsftpd.conf /etc/fail2ban/filter.d/vsftpd.conf

CMD [ "fail2ban-server", "-f" ]