# Docker-NSOT-Mysql
Docker container that runs NSOT (network source of truth) w/ AWS RDS Mysql backend. This container will build out a single  NSOT (Network Source of Truth) frontend app container that will connect back to the RDS MySQL cluster you speficy. Please follow the steps below when using this container: Prep Step: Create your own Public RDS MySQL instance in AWS and grab the hostname/port needed to connect to the MySQL cluster. You will be passing these values to the container via the Docker run statement below:
1. git clone this repo.
2. run docker build -t nsot:master
3. set the required env variables that will be passed to the docker container:
   i.   export RDS_NAME=[DB name]
   ii.  export RDS_USER=[DB user name]
   iii. export RDS_PASS=[DB password]
   iv.  export RDS_HOST=[DB hostname/CNAME]
   v.   export RDS_PORT=[DB port]
   vi.  export NSOT_EMAIL=[email address used as username when logging in to NSOT frontend]
   vii. export NSOT_PASS=[NSOT password] 
4. docker run -itd --restart always --privileged  --name nsot --net host -e RDS_NAME=$RDS_NAME -e RDS_USER=$RDS_USER -e RDS_PASS=$RDS_PASS -e RDS_HOST=$RDS_HOST -e RDS_PORT=$RDS_PORT -e EMAIL=$NSOT_EMAIL -e PASS=NSOT_PASS nsot:master
5. login to the container and create your nsot-server superuser account:
   i. docker exec -it nsot /bin/bash
   ii. nsot-server createsuperuser "Use this username/password to login to the webui for NSOT"
