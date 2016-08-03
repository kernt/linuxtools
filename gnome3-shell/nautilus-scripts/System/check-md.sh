#!/bin/bash

# AUTHOR:	(c) Tony Mattsson <tony_mattsson@home.se>
# VERSION:	1.0
# LICENSE:	GPL (http://www.gnu.org/licenses/gpl.html)
# REQUIRES:	gxmessage, md5sum, mawk, zenity
# NAME:		Check md5
# DESCRIPTION:	Checks the md5 hash checksum of files listed in a .md5-file

# Language settings

               Passed="OK"
               Failed="FAILED"
               PrintAllOk="All files are OK!"
               PrintFail1="file(s) are OK and"
               PrintFail2="file(s) are corrupt!"

case $LANG in
        sv* )
               Passed="OK"
               Failed="MISSLYCKADES"
               PrintAllOk="Alla filer Ã¤r OK!"
               PrintFail1="fil(er) Ã¤r OK och"
               PrintFail2="fil(er) Ã¤r korrupta!"
esac

for File in "$@"
do
 if [[ ${File:(( ${#File} -4 )):4} != ".md5" ]];then
    zenity --error --title="Check md5"--text="This is not a '.md5' checksum file."
    exit
 fi
# 1 Check the md5 file
(md5sum -c "$File" > /tmp/checktext.txt) 2>&1 | zenity --progress --title "Check md5" --text "Checking: $File" --pulsate --auto-close


# 2 Display the results!

# Print a little repport about how many failed and how many passed
NumberOK=`cat /tmp/checktext.txt | fgrep -o -e "$Passed" | wc -l`
NumberFailed=`cat /tmp/checktext.txt | fgrep -o -e "$Failed" | wc -l`
   if [ $NumberFailed == 0 ]; then
       StatusMessage="$PrintAllOk"
   else
       StatusMessage="$NumberOK $PrintFail1 $NumberFailed $PrintFail2"
   fi
echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-" >> /tmp/checktext.txt
echo "$StatusMessage" >> /tmp/checktext.txt

zenity --text-info --title "$File" --width=640 --height=480 --filename=/tmp/checktext.txt

done

