#!/bin/bash
#
# Shell script to rename given file names to from uppercase to
# lowercase OR lowercase to uppercase
#
# Copyright (C) 2005 nixCraft project.
#
# This script licensed under GNU GPL version 2.0 or above
#
# Support/FeedBack/comment : http://cyberciti.biz/fb/
# ---------------------------------
# To rename file uppercase to lowercase create sym link:
# ln -s /path/2upper /path/2lower
# --------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# --------------------------------
FILES="$1"
ME="$(basename $0)"

# function to display message and exit with given exit code
function die(){
  echo -e "$1"
  exit $2
}
     
# exit if no command line argument given
[ "$FILES" == "" ] && die "Syntax: $ME {file-name}\nExamples:\n $ME xyz\n $ME \"*.jpg\"" 1 || :
# scan for all input file
for i in $FILES
  do
  # see if upper to lower OR lower to upper by command name
  [ "$ME" == "2upper" ] && N="$(echo "$i" | tr [a-z] [A-Z])" || N="$(echo "$i" | tr [A-Z] [a-z])"
  # if source and dest file not the same then rename it
  [ "$i" != "$N" ] && mv "$i" "$N" || :
  done
