#!/bin/bash
#
# this code will determine exactly the path and the type of object,
# then it will decide use gedit or nautilus to open it by ROOT permission
#
#
# Nov 19, 2010
#Copyright by Nguyen Duc Long <Email: longnd.s8@gmail.com>
####################################################################################

# Determine the path
if [ -e -n $1 ]; then
	obj="$NEMO_SCRIPT_SELECTED_FILE_PATHS"
else
	base="`echo $NEMO_SCRIPT_CURRENT_URI | cut -d'/' -f3- | sed 's/%20/ /g'`"
	obj="$base/${1##*/}"
fi
# Determine the type and run as ROOT
if [ -f "$obj" ]; then
	gksu gedit "$obj"
elif [ -d "$obj" ]; then
	gksu nemo "$obj"
fi

exit 0

