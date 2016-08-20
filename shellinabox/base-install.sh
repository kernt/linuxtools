#!/bin/bash
#
#
#
#
# if ubuntu
# ins_ubuntu()
sudo apt-get install openssl 

# ins_ssl()
cd /opt/cert 
sudo openssl req -new -x509 -keyout certificate.pem -out certificate.pem -days 365 -nodes && chmod 644 certificate.pem

#
