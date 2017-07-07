#!/bin/bash

 wget --quiet https://pypi.python.org/packages/40/9b/0bc869f290b8f49a99b8d97927f57126a5d1befcf8bac92c60dc855f2523/mysqlclient-1.3.10.tar.gz  
 sudo tar -xvzf mysqlclient-1.3.10.tar.gz 
 echo Y | sudo apt install libmysqlclient-dev 
 cd mysqlclient-1.3.10 
 sudo python setup.py build 
 sudo python setup.py install 
 echo Y | sudo pip install nsot  
 echo Y | sudo pip install pynsot  
 cd ~/ 
 sudo nsot-server init  
 chmod +x ~/generate-nsot-configs.sh 
 sudo ~/generate-nsot-configs.sh $RDS_NAME $RDS_USER $RDS_PASS $RDS_HOST $RDS_PORT  
 cat input.txt | nohup sudo nsot-server start 
 sleep 1