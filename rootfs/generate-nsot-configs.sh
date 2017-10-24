#!/bin/bash

export RDS_NAME=$1
export RDS_USER=$2
export RDS_PASS=$3
export RDS_HOST=$4
export RDS_PORT=$5
export EMAIL=$6

export LOCAL_IP="$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
echo "Generating NSOT CONFIGs..."
 cat << EOF > ~/.pynsotrc
[pynsot]
url = http://$LOCAL_IP:8990/api
auth_header = X-NSoT-Email
default_domain = localhost
email = $EMAIL
default_site = 1
auth_method = auth_header
EOF

cat << EOF > ~/.nsot/nsot.conf.py
"""
This configuration file is just Python code. You may override any global
defaults by specifying them here.

For more information on this file, see
https://docs.djangoproject.com/en/1.8/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.8/ref/settings/
"""
from nsot.conf.settings import *

import os.path

# Path where the config is found.
CONF_ROOT = os.path.dirname(__file__)

# A boolean that turns on/off debug mode. Never deploy a site into production
# with DEBUG turned on.
# Default: False
DEBUG = False

############
# Database #
############
# https://docs.djangoproject.com/en/dev/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '$RDS_NAME',
        'USER': '$RDS_USER',
        'PASSWORD': '$RDS_PASS',
        'HOST': '$RDS_HOST',
        'PORT': '$RDS_PORT',
    }
}

###############
# Application #
###############

# The address on which the application will listen.
# Default: localhost
NSOT_HOST = '$LOCAL_IP'

# The port on which the application will be accessed.
# Default: 8990
NSOT_PORT = 8990

# The number of gunicorn worker processes for handling requests.
# Default: 4
NSOT_NUM_WORKERS = 4

# Timeout in seconds before gunicorn workers are killed/restarted.
# Default: 30
NSOT_WORKER_TIMEOUT = 30

# If True, serve static files directly from the app.
# Default: True
SERVE_STATIC_FILES = True

############
# Security #
############

# A URL-safe base64-encoded 32-byte key. This must be kept secret. Anyone with
# this key is able to create and read messages. This key is used for
# encryption/decryption of sessions and auth tokens.
SECRET_KEY = 'Z-r4COGCX7EPfVEXkEWce_ssR9FpZeQbEw2PeeFq1nQ='

# Header to check for Authenticated Email. This is intended for use behind an
# authenticating reverse proxy.
USER_AUTH_HEADER = 'X-NSoT-Email'

# The age, in seconds, until an AuthToken granted by the API will expire.
# Default: 600
AUTH_TOKEN_EXPIRY = 600  # 10 minutes

# A list of strings representing the host/domain names that this Django site
# can serve. This is a security measure to prevent an attacker from poisoning
# caches and triggering password reset emails with links to malicious hosts by
# submitting requests with a fake HTTP Host header, which is possible even
# under many seemingly-safe web server configurations.
# https://docs.djangoproject.com/en/1.8/ref/settings/#allowed-hosts
ALLOWED_HOSTS = ['*']

EOF
