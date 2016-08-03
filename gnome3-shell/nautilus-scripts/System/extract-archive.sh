#!/bin/bash

# AUTHOR:	Tony Mattsson <tony_mattsson@home.se>
# VERSION:	1.21
# LICENSE:	GPL (http://www.gnu.org/licenses/gpl.html)
# REQUIRES:	bzcat, zcat, lzop, 7za, zip, tar, unrar, pv, zenity, file, fgrep
#		sed, cat, mawk, stat
# NAME:		Star extraction script
# DESCRIPTION:	A bash shell script that extracts archives from Gnome Nautilus. It supports posix tar,
#               gnu tar and tar compressed with bzip2, gzip and lzop. It also supports 7z and zip
#               archives plus multipart archives of all types except zip.
#

# Check if more unusual commands are there
if [ $(basename `which pv`) != "pv" ]; then
zenity --error --title "Star compression script" --text="Necessary command 'pv' cannot be found."
exit
fi
if [ $(basename `which lzop`) != "lzop" ]; then
zenity --error --title "Star compression script" --text="Necessary command 'lzop' cannot be found."
exit
fi
if [ $(basename `which star`) != "star" ]; then
zenity --error --title "Star compression script" --text="Necessary command 'star' cannot be found."
exit
fi
if [ $(basename `which 7za`) != "7za" ]; then
zenity --error --title "Star compression script" --text="Necessary command '7za' cannot be found."
exit
fi
if [ $(basename `which unrar`) != "unrar" ]; then
zenity --error --title "Star compression script" --text="Necessary command 'unrar' cannot be found."
exit
fi

# Did the user select any file at all?
if [ $# == 0 ]; then
zenity --error --title "Star extraction script" --text="You did not select a file 
or folder for extraction."
exit
fi

# Try to cut past Nautilus bug concerning compression in the home directory
if [ $NAUTILUS_SCRIPT_CURRENT_URI == "x-nautilus-desktop:///" ]; then
   cd "$HOME/Desktop"
fi

# Functions
CheckFile() {
  if [ -f "$OutPutName" ]
then
  if ! zenity --question \
          --title "Star extraction script" \
          --text="The file \"$OutPutName\" already exists.

Do you want to overwrite it?"
  then
    exit
  fi
fi
} 

# Start main loop
for File in "$@"
do

FileType=`file "$File"`

# Check if user selected a ZIP file, and extract
ArchType=`echo "$FileType" | fgrep -m 1 -c "Zip archive data"`
if [ $ArchType == 1 ]; then
(unzip "$File") | 2>&1 zenity --progress \
--title="Star extraction script" \
--text="Extracting: $File" \
--percentage=0 \
--auto-close \
--pulsate
fi

# Check if user selected a 7z file, and extract
ArchType=`echo "$FileType" | fgrep -m 1 -c "7z archive data"`
if [ $ArchType == 1 ]; then
(7za x "$File") | 2>&1 zenity --progress \
--title="Star extraction script" \
--text="Extracting: $File" \
--percentage=0 \
--auto-close \
--pulsate
fi

# Check if user selected a rar file, and extract
ArchType=`echo "$FileType" | fgrep -m 1 -c "RAR archive data"`
if [ $ArchType == 1 ]; then
(unrar x -y "$File") | 2>&1 zenity --progress \
--title="Star extraction script" \
--text="Extracting: $File" \
--percentage=0 \
--auto-close \
--pulsate
fi

# Check if user selected a tar file, and extract
ArchType=`echo "$FileType" | fgrep -m 1 -c "tar archive"`
if [ $ArchType == 1 ]; then
CatFile=${File/tar.part.000/tar.part.}
FileSize=`stat -c %s -- "$CatFile"* | mawk '{sum = sum + $1} END {print sum}'`
(cat "$CatFile"* | pv -n -s $FileSize | star -x) 2>&1 | zenity --progress --title "Star extraction script" --text "Extracting archive: $File" --percentage=0 --auto-close
fi

# Check if user selected a tar.bz2 file, and extract
ArchType=`echo "$FileType" | fgrep -m 1 -c "bzip2 compressed data"`
ValTar=`bzcat -dc "$File" | head -c 1024 | file - | fgrep -m 1 -c "tar archive"`
if [[ $ArchType == 1 && $ValTar == 1 ]]; then
CatFile=${File/tar.bz2.part.000/tar.bz2.part.}
FileSize=`stat -c %s -- "$CatFile"* | mawk '{sum = sum + $1} END {print sum}'`
(cat "$CatFile"* | pv -n -s $FileSize | bzcat -| star -x) 2>&1 | zenity --progress --title "Star extraction script" --text "Extracting archive: $File" --percentage=0 --auto-close
elif [[ $ArchType == 1 && $ValTar == 0 ]]; then
OutPutName=`basename "$File" .bz2`
CheckFile
FileSize=$(stat -c %s -- "$File")
(cat "$File" | pv -n -s $FileSize | bzcat - | cat > "$OutPutName") 2>&1 | zenity --progress --title "Star extraction script" --text "Extracting archive: $File" --percentage=0 --auto-close
fi

# Check if user selected a tar.gz file, and extract
ArchType=`echo "$FileType" | fgrep -m 1 -c "gzip compressed data"`
ValTar=`zcat -dc "$File" | head -c 1024 | file - | fgrep -m 1 -c "tar archive"`
if [[ $ArchType == 1 && $ValTar == 1 ]]; then
CatFile=${File/tar.gz.part.000/tar.gz.part.}
FileSize=`stat -c %s -- "$CatFile"* | mawk '{sum = sum + $1} END {print sum}'`
(cat "$CatFile"* | pv -n -s $FileSize | zcat - | star -x) | zenity --progress --title "Star extraction script" --text "Extracting archive: $File" --percentage=0 --auto-close
elif [[ $ArchType == 1 && $ValTar == 0 ]]; then
OutPutName=`basename "$File" .gz`
CheckFile
FileSize=$(stat -c %s -- "$File")
(cat "$File" | pv -n -s $FileSize | zcat - | cat > "$OutPutName") 2>&1 | zenity --progress --title "Star extraction script" --text "Extracting archive: $File" --percentage=0 --auto-close
fi

# Check if user selected a tar.lzop file, and extract
ArchType=`echo "$FileType" | fgrep -m 1 -c "lzop compressed data"`
ValTar=`lzop -dc "$File" | head -c 1024 | file - | fgrep -m 1 -c "tar archive"`
if [[ $ArchType == 1 && $ValTar == 1 ]]; then
CatFile=${File/tar.lzo.part.000/tar.lzo.part.}
FileSize=`stat -c %s -- "$CatFile"* | mawk '{sum = sum + $1} END {print sum}'`
(cat "$CatFile"* | pv -n -s $FileSize | lzop -dc - | star -x) 2>&1 | zenity --progress --title "Star extraction script" --text "Extracting archive: $File" --percentage=0 --auto-close
elif [[ $ArchType == 1 && $ValTar == 0 ]]; then
OutPutName=`basename "$File" .lzo`
CheckFile
FileSize=$(stat -c %s -- "$File")
(cat "$File" | pv -n -s $FileSize | lzop -dc - | cat > "$OutPutName") 2>&1 | zenity --progress --title "Star extraction script" --text "Extracting archive: $File" --percentage=0 --auto-close
fi

done # Ok Captain, next file

