FROM ubuntu:16.04
MAINTAINER Jeremiah Gearheart <jeremiah.gearheart@gmail.com>
EXPOSE 8990

# These are the supported environment variables.
# This Docker container was developed to use an AWS 
# RDS Mysql backend configuration instead of the default SQLLite:
#     DB_ENGINE
#     DB_NAME
#     DB_USER
#     DB_PASSWORD
#     DB_HOST
#     DB_PORT
#
#     NSOT_EMAIL
#     NSOT_SECRET

COPY rootfs /

RUN chmod +x /run.sh
RUN chmod +x /core.sh
RUN chmod +x /update.sh
RUN chmod -R 755 /etc/confd

CMD ["/run.sh"]
