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


RUN apt-get -y update \ 
&& apt-get -y install build-essential python-dev libffi-dev libssl-dev libmysqlclient-dev \
&& apt-get -y install python-pip git wget mysql-client-core-5.7 \ 
&& pip install nsot pynsot 
RUN wget --quiet https://pypi.python.org/packages/40/9b/0bc869f290b8f49a99b8d97927f57126a5d1befcf8bac92c60dc855f2523/mysqlclient-1.3.10.tar.gz  \
&& tar -xvzf mysqlclient-1.3.10.tar.gz && cd mysqlclient-1.3.10 && python setup.py build && python setup.py install 

RUN chmod +x /run.sh
RUN chmod +x /generate-nsot-configs.sh


CMD ["/run.sh"]
CMD ["nsot-server start &"]
