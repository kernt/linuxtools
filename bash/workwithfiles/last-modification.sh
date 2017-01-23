#!/bin/bash
# Write a shell script that displays the last modification time of any file.
# ------------------------------------------------
# Copyright (c) 2008 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
#---------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# ---------------------------------------------------
     
echo -n "Enter a filename to see last modification time : "
read fileName
     
# make sure file exits
if [ ! -f $fileName ]
  then
    echo "$fileName not a file"
    exit 1
fi
     
# use stat command to display
echo "$fileName was last modified on $(stat -c %x $fileName)"
