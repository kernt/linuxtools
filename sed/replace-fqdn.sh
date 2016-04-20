#!/bin/bash
# source: https://github.com/ArchipelProject/Archipel/wiki/Ejabberd%3A-Configuration

FQDN="$1"
HOSTS="$2"

sed -i "s/FQDN/$FQDN/" $HOSTS

exit 0 
