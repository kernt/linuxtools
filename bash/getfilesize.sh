#!/bin/bash
#
#Author : Tobias Kern
# 
# Prevent for svn/git commit with zero size!
FSIZE=stat -c%s $1 
# if [ $FSIZE = 0 ] ; then
#  echo "Error you will commit files with 0 size. "
#  echo "Error"
# fi

#perl -e '@x=stat(shift);print $x[7]' FILE
#or even:
#ls -nl FILE | awk '{print $5}'
