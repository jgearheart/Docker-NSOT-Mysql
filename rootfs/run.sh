#!/bin/bash

 #wget --quiet https://pypi.python.org/packages/40/9b/0bc869f290b8f49a99b8d97927f57126a5d1befcf8bac92c60dc855f2523/mysqlclient-1.3.10.tar.gz  
 #tar -xvzf mysqlclient-1.3.10.tar.gz 
 #echo Y | apt install libmysqlclient-dev 
 #cd mysqlclient-1.3.10 
 #python setup.py build 
 #python setup.py install 
 #echo Y | pip install nsot  
 #echo Y | pip install pynsot  
 #echo Y | apt install mysql-client-core-5.7
 cd / 
 nsot-server init   
 /generate-nsot-configs.sh $RDS_NAME $RDS_USER $RDS_PASS $RDS_HOST $RDS_PORT  
 nohup nsot-server start > logit &
 sleep 30


