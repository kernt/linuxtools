#!/usr/bin/env bash
#
# Script-Name : $SCRIPTNAME.sh
# Version : 0.01
# Autor : $AUTUR
# Datum : $DATE
# Lizenz : GPLv3
# Depends : autoconf make 
# Use :
#
# Description:
# Source: http://source.a2o.si/download/snoopy/ https://github.com/a2o/snoopy
###########################################################################################
## Some Info and so one.
##
###########################################################################################
autoconf
./configure
make
make install
make enable
