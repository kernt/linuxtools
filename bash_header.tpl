#!/bin/bash
#
# Script-Name	: $@.sh
# Version	    : 0.01
# Autor		    : Tobias Kern
# Datum		    : $DATE
# Lizenz	    : GPLv3
# Depends     :
# Use         :       
# 
# Example:
#
# Description:
###########################################################################################
## Some Info and so one.
##
###########################################################################################
#########                            ERROR Codes                          #################
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
##################################################################################################
########## Bach environmentvaribles
##################################################################################################
# Posision from funktion to script
POSTOFONCA="*"

# Posision from funktion to script
POSTOFONCONCE="@"

# Options by execute bash
BASCHEXECOP="-"

# Exit state from last command
STATELASTCOMMAND="?"

# Variable for optionsswitch
#OPTFILE=""
fbname=$(basename "$1".txt)


# simple help funktion
function usage {
 echo "Usage: $SCRIPTNAME [-h] [-v] [-o arg] file ..." >&2
 [[ $# -eq 1 ]] && exit $1 || exit $EXIT_FAILURE
}
