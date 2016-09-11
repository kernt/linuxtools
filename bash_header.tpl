#!/bin/bash
# Sources:   http://www.gmarik.info/blog/2016/5-tips-for-solid-bash-code/
#            
# Script-Name	: $@.sh
# Version	    : 0.01
# Autor		     : Tobias Kern
# Datum		     : $DATE
# Lizenz	     : GPLv3
# Depends     :
# Use         :       
# 
# Example:
#
# Description:
###########################################################################################
# -e      Exit immediately if a pipeline (which may consist of a single simple command), 
#         a list, or a compound command, exits with a non-zero status.
#  -x     After expanding each simple command, for command, case command, 
#         select command, or arithmetic for command, display the expanded value of PS4, 
#         followed by the command and its expanded arguments or associated word list.
###
#  ${parameter:?word}     Display Error if Null or Unset. If parameter is null or unset, 
#                         the expansion of word (or a message to that effect if word is not present) 
#                         is written to the standard error and the shell, 
#                         if it is not interactive, exits. Otherwise, the value of parameter is substituted.
# a example:
#
#$ echo ${HOME?"Must be set"}
#/Users/gmarik
#
#$ echo ${DOME?"Must be set"}
#-bash: DOME: Must be set
#
#$ echo $?
#1
##
# 
#
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
# Posision from function to script
POSTOFONCA="*"

# Posision from function to script
POSTOFONCONCE="@"

# Options by execute bash
BACHEXECOP="-"

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

