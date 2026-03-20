FROM debian:bookworm

RUN apt update && apt install -y vsftpd && apt clean

COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

# Create uploads folder for FTP
RUN mkdir -p /var/www/wordpress/wp-content/uploads

EXPOSE 21
EXPOSE 10000-10010

ENTRYPOINT ["/init.sh"]