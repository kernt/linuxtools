#!/bin/bash
#
# Script-Name : dmesg4humans.sh
# Version : 0.01
# Autor   : Tobias Kern
# Datum   : 26-01-2015
# Lizenz  : GPLv3
# Depends : gnutools 
# Use     : execute only
#
# Description:
# make dmesg timestamp human readable
###########################################################################################
## Some Info and so one.
##
###########################################################################################
# Name of your script.
SCRIPTNAME=$(basename $0.sh)
# exit code without any error
EXIT_SUCCESS=0
# exit code I/O failure
EXIT_FAILURE=1
# exit code error if known
EXIT_ERROR=2
# unknown ERROR
EXIT_BUG=10

dmesg -T
