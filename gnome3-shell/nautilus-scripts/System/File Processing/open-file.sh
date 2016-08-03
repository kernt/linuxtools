#!/bin/bash
#
# Nautilus script -> open gedit
#
# Owner : Largey Patrick from Switzerland
#   	  patrick.largey@nazeman.org
#		 www.nazeman.org
#
# Licence : GNU GPL 
#
# Copyright (C) Nazeman
#
# Ver. 0.9-1 Date: 16.02.2002
# Add multiple file open in the same windows
#
# Ver: 0.9  Date: 27.10.2001
# Initial release
#
# Dependence : Nautilus (of course)
#			  Gnome-utils (gdialog)
#
filesall=""
while [ $# -gt 0 ]
	do
		files=`echo "$1" | sed 's/ /\?/g'`
		filesall="$files $filesall"
		shift
	done
gedit $filesall&

