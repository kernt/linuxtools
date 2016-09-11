#!/bin/bash
# Shell script to create files and directories that do not exist
# This script also demonstrate use of functions and command line arguments using getopts command
# -------------------------------------------------------------------------
# Copyright (c) 2004 nixCraft project <http://www.cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# ----------------------------------------------------------------------
usage(){
echo "Usage: $0 {-f filename} {-d dirname}"
exit 1
}
     
createDir(){
  if [ ! -d $1 ]
    then
     /bin/mkdir -p $1 >/dev/null 2>&1 && echo "Directory $1 created." || echo "Error: Failed to create $1 directory."
    else
     echo "Error: $1 directory exits!"
  fi
  }
     
createFile(){
  if [ ! -f $1 ]
    then
     touch $1 > /dev/null 2>&1 && echo "File $1 created." || echo "Error: Failed to create $1 files."
    else
     echo "Error: $1 file exists!"
  fi
  }
     
while getopts f:d:v option
   do
   case "${option}"
    in
    f) createFile ${OPTARG};;
    d) createDir ${OPTARG};;
    \?) usage
    exit 1;;
   esac
  done
    
    
#multi-process safe
## Print only the command name, not the full path.
## Send the output to stderr, not stdout
#usage(){
#  echo "Usage: ${0##*/} [-f filename ] ... | [ -d dirname ] ..." >&2
#  exit 1
#}
#
#
#
### Quote $1 or it will fail if an argument contains whitespace
#createDir(){
#if [ ! -d "$1" ]
#then
#mkdir -p "$1" >/dev/null 2>&1 && echo "Directory $1 created." || echo "Error: Failed to create $1 directory."
#else
#echo "Error: $1 directory exits!"
#fi
#}
