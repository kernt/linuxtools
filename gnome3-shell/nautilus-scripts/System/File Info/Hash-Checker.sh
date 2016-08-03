#!/bin/bash

# ============================================================================================================================================================= #
# Hash Checker script for md5/sha1/sha256 hashes, version 4.0.7 by Cooleech
# e-mail to: cooleech@gmail.com
# English by Cooleech
# ============================================================================================================================================================= #

AppVer="4.0.7"
HConFile="$HOME/.gnome2/nautilus-scripts/.hashcheck/HC.conf"
SavedSettings=`cat $HConFile`

which xdg-user-dirs-update
if [ $? = 0 ]; then
.	~/.config/user-dirs.dirs # Import variables
fi

# Set desktop icon dir
if [ "$XDG_DESKTOP_DIR" = "" ]; then
	if [ -d "$HOME/.desktop" ]; then
		XDG_DESKTOP_DIR="$HOME/.desktop"
	else
		XDG_DESKTOP_DIR="$HOME"
	fi
fi

if [ -e $HConFile ]; then
.	$HConFile # Import variables
fi

if [ "$1" = "" ]; then
	SelectedFile=`zenity --title="Choose a file to check" --file-selection`
fi

if [ "$SelectedFile" = "" ]; then
	if [ $# -gt 1 ]; then
		zenity --error --text="You must select one file only!"
		exit 1
	fi
	if [ "$1" = "" ]; then
		exit 1
	fi
fi

if [ -d "$1" ]; then
	zenity --error --text="<b>$1</b> is a folder.
This script cannot work with folders!"
	exit 1
fi

if [ "$SelectedFile" = "" ]; then
	SelectedFile="$1"
fi

SelectedFileNameFix="${SelectedFile//'&'/&amp;}" # Fix for ampersand simbol

if [ `stat --printf="%s" "$SelectedFile"` = "0" ]; then
	zenity --warning --text="<b>$SelectedFileNameFix</b> has 0 bytes!
Checking hash of this file is pointless!"
	exit 1
fi

if [ -d "${SelectedFile%/*}" ]; then # Check if dir or file
	FileNoPath="${SelectedFileNameFix##*/}"
	FilePath="${SelectedFile%/*}/" # md5sum, sha1sum and sha256sum need file path
else
	FileNoPath="$SelectedFileNameFix"
	FilePath="./" # md5sum, sha1sum and sha256sum need file path
fi

function DELETE_OLD_HASH_FILE {
zenity --question --title="Hash Checker $AppVer" --text="Found old hash file:\n<b>$FileNoPath$HashFile</b>\n\nWould you like to delete it (recommended)?" \
			--cancel-label="_Keep it" --ok-label="_Delete it"
if [ $? = 0 ]; then
	rm -f "$SelectedFile$HashFile" # Must keep path
fi
}

if [ -e "$SelectedFile".md5sum ]; then # Must keep path
	HashFile=".md5sum"
	DELETE_OLD_HASH_FILE
fi

if [ -e "$SelectedFile".sha1sum ]; then # Must keep path
	HashFile=".sha1sum"
	DELETE_OLD_HASH_FILE
fi

if [ -e "$SelectedFile".sha256sum ]; then # Must keep path
	HashFile=".sha256sum"
	DELETE_OLD_HASH_FILE
fi

# Get last states
if [ "$MD5_HASH_CHECKED" = "" ]; then
	MD5state="TRUE"
else
	MD5state="$MD5_HASH_CHECKED"
fi

if [ "$SHA1_HASH_CHECKED" = "" ]; then
	SHA1state="FALSE"
else
	SHA1state="$SHA1_HASH_CHECKED"
fi

if [ "$SHA256_HASH_CHECKED" = "" ]; then
	SHA256state="FALSE"
else
	SHA256state="$SHA256_HASH_CHECKED"
fi

if [ "$SAVE_TO_TEXT_FILE" = "" ]; then
	TextFileState="FALSE"
else
	TextFileState="$SAVE_TO_TEXT_FILE"
fi

if [ -r "$SelectedFile" ]; then
	TypeOfHash=`zenity --width=400 --height=250 --list --checklist --title="Hash Checker $AppVer" --text="Select check type for <b>$FileNoPath</b> file" \
			--column "What" --column "to check" $MD5state MD5 $SHA1state SHA1 $SHA256state SHA256 $TextFileState "Save hash result into text file"`
else
	zenity --error --text "You don't have read permission for this file!"
	exit 1
fi

if ! [ -e "$SelectedFile" ]; then
	zenity --error --text "Cannot find <b>$FileNoPath</b> file!\nFile is either renamed, moved or removed!"
	exit 1
fi
# Reset all
MD5state="FALSE"
SHA1state="FALSE"
SHA256state="FALSE"
TextFileState="FALSE"

case $TypeOfHash in
MD5*) # MD5 with any other
MD5state="TRUE"
(
echo "# Checking MD5 hash. Depending on '$FileNoPath' file size,\ndisc and CPU speed, it could take up to several minutes. Please wait..."
md5sum "$SelectedFile" > /tmp/"$FileNoPath".md5sum
) | zenity --width="400" --progress --title="Checking MD5 hash" --text="" --percentage=0 --auto-close --pulsate
esac

case $TypeOfHash in
*SHA1*) # SHA1 with any other
SHA1state="TRUE"
(
echo "# Checking SHA1 hash. Depending on '$FileNoPath' file size,\ndisc and CPU speed, it could take up to several minutes. Please wait..."
sha1sum "$SelectedFile" > /tmp/"$FileNoPath".sha1sum
) | zenity --width="400" --progress --title="Checking SHA1 hash" --text="" --percentage=0 --auto-close --pulsate
esac

case $TypeOfHash in
*SHA256*) # SHA256 with any other
SHA256state="TRUE"
(
echo "# Checking SHA256 hash. Depending on '$FileNoPath' file size,\ndisc and CPU speed, it could take up to several minutes. Please wait..."
sha256sum "$SelectedFile" > /tmp/"$FileNoPath".sha256sum
) | zenity --width="400" --progress --title="Checking SHA256 hash" --text="" --percentage=0 --auto-close --pulsate
esac

case $TypeOfHash in
*Save*) # Save in text file with any other
TextFileState="TRUE"
esac

case $TypeOfHash in
Save*) # Save in text file only
exit 1
esac

case $TypeOfHash in
"") # No selection
exit 1
esac

CurrentSettings="# HASH CHECKER SETTINGS

MD5_HASH_CHECKED=$MD5state
SHA1_HASH_CHECKED=$SHA1state
SHA256_HASH_CHECKED=$SHA256state
SAVE_TO_TEXT_FILE=$TextFileState"

if [ ! "$SavedSettings" = "$CurrentSettings" ]; then
	echo "$CurrentSettings" > $HConFile
fi

if [ -e /tmp/"$FileNoPath".md5sum ]; then
	MD5hash=`cat /tmp/"$FileNoPath".md5sum`
	MD5WithoutPath="${MD5hash%%  $SelectedFile}"
else
	MD5WithoutPath="N/A"
fi

if [ -e /tmp/"$FileNoPath".sha1sum ]; then
	SHA1hash=`cat /tmp/"$FileNoPath".sha1sum`
	SHA1WithoutPath="${SHA1hash%%  $SelectedFile}"
else
	SHA1WithoutPath="N/A"
fi

if [ -e /tmp/"$FileNoPath".sha256sum ]; then
	SHA256hash=`cat /tmp/"$FileNoPath".sha256sum`
	SHA256WithoutPath="${SHA256hash%%  $SelectedFile}"
else
	SHA256WithoutPath="N/A"
fi

if [ "$TextFileState" = "TRUE" ]; then
	if [ -e /tmp/"$FileNoPath".md5sum ]; then
		md5hashFile=`cat /tmp/"$FileNoPath".md5sum`
		echo "$md5hashFile" >> "$SelectedFile".md5sum
	fi
	if [ -e /tmp/"$FileNoPath".sha1sum ]; then
		sha1hashFile=`cat /tmp/"$FileNoPath".sha1sum`
		echo "$sha1hashFile" >> "$SelectedFile".sha1sum
	fi
	if [ -e /tmp/"$FileNoPath".sha256sum ]; then
		sha256hashFile=`cat /tmp/"$FileNoPath".sha256sum`
		echo "$sha256hashFile" >> "$SelectedFile".sha256sum
	fi
fi

zenity --question --title="Hash Checker $AppVer" --no-wrap --text="File: <b>$FileNoPath</b>
\nMD5 hash: <b>$MD5WithoutPath</b>\nSHA1 hash: <b>$SHA1WithoutPath</b>\nSHA256 hash: <b>$SHA256WithoutPath</b>\n
Would you like to open web browser and compare hash from Google?" --cancel-label="_Exit" --ok-label="_Google it"

if [ $? = 0 ]; then
	case $TypeOfHash in
	MD5*)
	SearchString="$MD5WithoutPath  "
	esac
	case $TypeOfHash in
	*SHA1*)
	SearchString="$SearchString$SHA1WithoutPath  "
	esac
	case $TypeOfHash in
	*SHA256*)
	SearchString="$SearchString$SHA256WithoutPath  "
	esac
	SearchString="$SearchString$FileNoPath"
	which xdg-user-dirs-update
	if [ $? = 0 ]; then
		xdg-open "http://www.google.com/search?q=$SearchString"
	else
		zenity --error --text "ERROR: NO XUD"
	fi
fi

# Cleanup /tmp
if [ -e /tmp/"$FileNoPath".md5sum ]; then
	rm -f /tmp/"$FileNoPath".md5sum
fi
if [ -e /tmp/"$FileNoPath".sha1sum ]; then
	rm -f /tmp/"$FileNoPath".sha1sum
fi
if [ -e /tmp/"$FileNoPath".sha256sum ]; then
	rm -f /tmp/"$FileNoPath".sha256sum
fi

exit 0

# =========================================================== Created using Setup v3.6 by Cooleech ============================================================ #
