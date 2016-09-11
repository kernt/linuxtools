#!/bin/sh
##########################################################################
# Title      :	
# Author     :	Tobias Kern
# Date       :	Dezember 23 2007
# Category   :	System Administration
#
##########################################################################
# Discrition
#
##########################################################################
ROOTID=0
SKRIPTNAME=$@

# Wichtig Pruefung das der Benutzer Root ist!!!!

  if [ `id -u` != 0 ]; then
    echo "Das Script kann nur als Benutzer Root Ausgefuehrt werden!"
    sleep 2
    exit 1
  fi

# loguser
# USERIDOUT=/tmp/bashtest.useridout
# 
# 
# echo "Skriptname ist = $SKRIPTNAME"
# cut -d: -f1,3,7 /etc/passwd >/tmp/bashtest.out
# 
# echo "Die \$SHELL Umgebungsvariable hat die $SHELL"
# 
# if [[  ]]; then
# 	echo "Lege im Verzeichnis /tmp/ die Datei bashtest.useridout an"
# fi
# 
# chmod +x bashtest.sh
# 
# exit 0
