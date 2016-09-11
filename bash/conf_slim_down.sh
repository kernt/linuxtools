#!/usr/bin/env bash
#
# Script-Name : conf_slim_down.sh
# Version : 0.01
# Autor : $USER
# Datum : $DATE
# Lizenz : GPLv3
# Depends : grep
# Use :
#
# Example:
#      conf_slim_down.sh /etc/apache2/apache2.conf
# Description:
###########################################################################################
## Some Info and so one.
##
###########################################################################################

FILE=$1

# most usible in Unix/Linux
grep -Ev '^(#|$)'
 # better for Windows for example opsi files
  # grep -Ev '^(#|;)'

exit 0
