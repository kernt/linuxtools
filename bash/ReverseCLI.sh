#!/bin/bash
# Write a shell program that outputs all integers upto the command line
# parameter starting from 1 and also should output the same numbers
# in the reverse order.
# --------------------------------------------------------------------
# This is a free shell script under GNU GPL version 2.0 or above
# Copyright (C) 2005 nixCraft project.
# Feedback/comment/suggestions : http://cyberciti.biz/fb/
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
if [ $# -eq 0 ]
  then
    echo "$0 num1, num2, numN"
  exit 1
    fi
     x=""
     echo -n "Numbers are : "
      for n in $@
      do
       echo -n $n
       echo -n " "
       x="$n $x"
      done
    echo ""
    echo -n "Reverse order: "
    echo $x
