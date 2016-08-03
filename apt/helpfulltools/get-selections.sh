#!/bin/bash
#
# Script-Name : get-selections.sh
# Version : 0.01
# Autor : Tobias Kern
# Datum : $DATE
# Lizenz : GPLv3
# Depends :
# Use :
#
# Example:
#
# Description:
###########################################################################################
## build a list with with your installed packages to copy to a different environment.
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

FILEOUT="/etc/apt/apt-build.list"

dpkg --get-selections | awk '{if ($2 == "install") print $1}'> $FILEOUT
