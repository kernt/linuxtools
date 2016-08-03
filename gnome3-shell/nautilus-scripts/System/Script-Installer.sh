#!/bin/bash
# Script-Installer
##########################################################################
#                        Nautilus Script Installer                       #
##########################################################################
#                                                                        #
# Created by Federico Vecchio (Vecna)                                    #
#                                                                        #
##########################################################################

wait='Script installed'
title_wait='Installing'

errors='An error has occured'
title_errors='Error'



if [[ ! -a "~/.gnome2/nautilus-scripts" ]]; then
	mkdir -p ~/.gnome2/nautilus-scripts
fi

echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | while read line
do
  if [ -n "$line" ]; then
    chmod +x "$line"
    mv "$line" ~/.gnome2/nautilus-scripts/
      zenity --info --title "$title_wait" --text "$wait";
    
    if [ "$?" -gt 0 ]; then
      zenity --error --text "$errors during the installation of $line" --title "$title_errors"
      exit 
    fi
  fi
done
