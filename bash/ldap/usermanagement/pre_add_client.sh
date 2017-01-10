#!/usr/bin/env bash
#
# Script-Name : pre_add_client.sh
# Version : 0.1
# Autor : Tobias Kern
# Datum : Mo 10 Mär 2014 13:40:46 CET 
# Lizenz : GPLv3
# 
# 
#
# Description:
###########################################################################################
## Schema files
##  dhcpd.schema
##    
##  
##  
##  
## Services:
##    Power DNS 
##    ISC DHCPD
###########################################################################################

DN=$1
MACADDRESS=$2
IP=$(hostname -i)
USER=$4
FIXADD="$MACADDRESS"
USERNAME=$USER
FQDN=$(hostname -f)
DESC=$(hostname)


echo "
dn: $DN
objectClass: dhcpHost
objectClass: top
objectClass: extensibleObject
cn: $FQDN
aRecord: $IP
associatedDomain: $FQDN
description: $DESC
dhcpHWAddress: ethernet $MACADDRESS
dhcpStatements: fixed-address $IP
dNSTTL: 3600

" > adduser.ldif

# very impotent last empty line

