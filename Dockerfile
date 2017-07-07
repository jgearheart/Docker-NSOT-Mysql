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

RUN echo Y | sudo apt-get -y install build-essential python-dev libffi-dev libssl-dev \
&& echo Y | sudo apt-get --yes install python-pip git \
&& wget --quiet https://pypi.python.org/packages/40/9b/0bc869f290b8f49a99b8d97927f57126a5d1befcf8bac92c60dc855f2523/mysqlclient-1.3.10.tar.gz \ 
&& sudo tar -xvzf mysqlclient-1.3.10.tar.gz \
&& echo Y | sudo apt install libmysqlclient-dev \
&& cd mysqlclient-1.3.10 \
&& sudo python setup.py build \
&& sudo python setup.py install \
&& echo Y | sudo pip install nsot \ 
&& echo Y | sudo pip install pynsot \ 
&& cd ~/ \
&& sudo nsot-server init \ 
&& chmod +x ~/generate-nsot-configs.sh \
&& sudo /tmp/generate-nsot-configs.sh $RDS_NAME $RDS_USER $RDS_PASS $RDS_HOST $RDS_PORT \ 
&& cat input.txt | nohup sudo nsot-server start \
&& sleep 1


         

#RUN chmod +x /run.sh



#CMD ["/run.sh"]
