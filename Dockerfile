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

COPY rootfs/generate-nsot-config.sh /
COPY rootfs/input.txt /
COPY rootfs/run.sh /

RUN echo Y | sudo apt-get -y install build-essential python-dev libffi-dev libssl-dev \
&& echo Y | sudo apt-get --yes install python-pip git 

RUN chmod +x /run.sh



CMD ["/run.sh"]
