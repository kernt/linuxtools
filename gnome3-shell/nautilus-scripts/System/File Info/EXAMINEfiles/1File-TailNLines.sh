#!/bin/sh
##
## Nautilus
## SCRIPT: big01b_1file_tailNlines.sh
##
## PURPOSE: Show the last N lines of the user-selected file.
##
## HOW TO USE: In Nautilus, navigate to a file, select it,
##             right-click and choose this Nautilus script to run.
##
## NOTE: Uses 'zenity' to prompt for N.
##
## Created: 2010may25
## Changed: 

## FOR TESTING:
# set -v
# set -x

#######################################
## Get the filename.
#######################################

#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# FILENAME="$@"
  FILENAME="$1"

#  CURDIR="$NAUTILUS_SCRIPT_CURRENT_URI"
   CURDIR="`pwd`"


#######################################################
## Check that the selected file is a text file.
## COMMENTED, for now.
#######################################################

#  FILECHECK=`file "$FILENAME" | egrep 'text|Mail|ASCII'`
 
#  if test "$FILECHECK" = ""
#  then
#     exit
#  fi

########################################################
## Initialize the output file.
##
## NOTE: If the user has write permission on the current
##       directory, we put the output file in the 'pwd'.
##       Otherwise, we put it in /tmp.
########################################################

  OUTFILE="00_temp_tail_Nlines.txt"
  if test ! -w "$CURDIR"
  then
     OUTFILE="/tmp/$OUTFILE"
  fi

  rm -f "$OUTFILE"


#################################
## Prompt for N.
#################################

CURDIRFOLD=`echo "$CURDIR" | fold -55`

    NLINES=""
    NLINES=`zenity --entry \
           --title "How many lines of the tail?" \
           --text "\
Enter a positive integer. That many lines of the 'tail' of file

     $FILENAME

in directory

     $CURDIRFOLD

will be extracted into output file

     '$OUTFILE'." \
           --entry-text "2000"`

    if test "$NLINES" = ""
    then
       exit
    fi


#######################################
## Generate the tail output.
#######################################

echo "\
Last $NLINES lines of file $FILENAME.
##########################
" > "$OUTFILE"

tail -$NLINES "$FILENAME" | nl -ba  >> "$OUTFILE"


############################
## Show the list.
############################

. $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &



