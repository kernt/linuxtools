#!/usr/bin/env bash
#
# Script-Name	: search_and_purge_app.sh
# Version	    : 0.01
# Autor		    : Tobias Kern
# Datum		    : 26-04-2014
# Lizenz	    : GPLv3
# Depends     : aptitude, awk, grep, 
# Use         : first argument is your application that you will to deinstall.
# 
# Example: search_and_purge_app.sh exim4
#
# Description:
###########################################################################################
## Use this carefully.
##
###########################################################################################

APP="$1"


aptitude purge $(aptitude search "$APP" | grep "^i" | awk '{print $2}')

exit 0
