#!/bin/sh
# http://g-scripts.sourceforge.net
# Released into the public domain.
#
for arg
do
 
filetype=$(file "$arg")

  gdialog --title "File-Type Determinator" --msgbox "File $filetype" 200 200

done

