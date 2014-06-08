#!/usr/bin/env bash
#
# Script-Name : $@.sh
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


# first use an arraey to get the list with the apps
# is only example change it for hand befor you use it !!!!!!
apps=(
 
vim
git
tree
php5
 
)

# secend if the file alls.list exists use this file.

# todo make function
# and add os detection

APPLIST= "applications.list"

if [  $APPLIST -s ]
  than
  # add function
  
fi

echo "no application.list found"


 
# Loop over apps and install each one with default 'yes' flag to prevent for questions from installer.

for app in "${apps[@]}"
  do
    apt-get install $app -y
done


exit $EXIT_SUCCESS
