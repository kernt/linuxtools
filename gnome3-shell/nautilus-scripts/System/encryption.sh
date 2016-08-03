#!/bin/bash
#
#  Nautilus file encryption/decryption script v2.4 - Uses GnuPG
#  Written by Robert Pectol, January 2006 - http://rob.pectol.com
#
#  This  encrypter/decrypter  script  must be  called from  Nautilus!
#  Place this script in your  nautilus-scripts directory and make sure
#  it's executable  (chmod 775 this_script.sh)  and it will show up in
#  the,  "Scripts" menu when files are right-clicked  from within your
#  Nautilus file  manager.  Please report any bugs to rob@pectol.com.
#
#  This script requires GnuPG for the file encryption/decryption.  It
#  is usually installed by  default on most  distributions.  However,
#  you may need to generate a key pair for your user account.  This is
#  easily accomplished by opening a shell and typing the following at
#  the command prompt:  "gpg --gen-key"  (Do *NOT* use sudo for this)
#  Once you have generated your keypair, you can start encrypting and
#  decrypting files with your key, using this script!  It's important
#  to NOT forget your passphrase or your encrypted files will be that
#  way forever!!!  This script  also requires  the wipe  command line
#  utility to handle  secure file  deletion.  If you  don't have  the
#  wipe  utility, you  can easily install  it by opening a  shell and
#  typing,  "sudo apt-get install wipe"  at the  command  prompt.
#
#  This  program is free  software.  It  is distributed  in the hope
#  that it will be useful, but WITHOUT ANY WARRANTY; without even the
#  implied warranty of  MERCHANTABILITY or FITNESS  FOR A PARTICULAR
#  PURPOSE.  See the  GNU General Public  License for  more details.
#
######################################################################

##################
#  USER OPTIONS  #
##################

#  Secure File Deletion
#  This option allows you to have the script securely delete
#  the original file from the disk once it's been successfully
#  encrypted.  Selecting, "no" here will leave the un-encrypted
#  version in place and intact so BE WARNED!  This feature uses
#  the wipe command line utility to destroy the original file
#  once it's been successfully encrypted.  Once the original
#  file has been wiped, it is gone!  The only recovery possible,
#  for that file, is to decrypt it's encrypted version.  Don't
#  forget your GnuPG passphrase!!!  Set this option to, "yes"
#  to activate this feature.
rm_cleartext_file="no"

#  Cypher-text File Deletion
#  This option allows you to have the script delete the
#  encrypted file once it's been successfully decrypted.
#  Set this option to, "yes" to activate this feature.
rm_cyphertext_file="no"

#  This option enables verbose feedback during script
#  execution.  With it disabled, only critical errors
#  and the final end results are displayed with minimal
#  verbosity.
verbose="yes"

#####################################################
#  YOU SHOULDN'T MODIFY ANYTHING BELOW THIS POINT!  #
#####################################################

# Set some script variables
the_file=$1
if [ "$NAUTILUS_SCRIPT_CURRENT_URI" == "x-nautilus-desktop:///" ]; then
	files_path=$HOME"/Desktop"
else
	files_path=`echo "$NAUTILUS_SCRIPT_CURRENT_URI" | sed -e 's/^file:\/\///; s/%20/\ /g'`
fi
gui=`which zenity`
enc_dec=`which gpg`
secure_delete=`which wipe`

# Secure file deletion disclaimer
agreed=`cat ~/.enc_dec_agreed` &> /dev/null
if [[ "$rm_cleartext_file" == "yes" && "$agreed" != "yes" ]]; then
	dialog_title="Disclaimer!"
	dialog_type="--question"
	ackn1="By activating the secure file deletion feature, you acknowledge"
	ackn2="that you understand the following:  Once the file is successfully"
	ackn3="encrypted to a new file, the original un-encrypted file will be"
	ackn4="securely deleted!  That is, it will be destroyed!  After that,"
	ackn5="the only hope of recovering the original file will be in the"
	ackn6="successful decryption of the encrypted one!  Don't forget your"
	ackn7="passphrase or your encrypted files will be that way forever!"
	ackn8="You also acknowledge that you absolve the author of this script,"
	ackn9="of any responsibility for accidental data loss due to your use of it."
	ackn10="You also acknowledge that you assume full responsibility for any and"
	ackn11="all data loss due to your use of it!  Select, 'Ok' to acknowledge."
	ackn12="(NOTE: This notice will only be shown once unless you decline to acknowledge!)"
	feedback=`echo $ackn1 $ackn2 $ackn3 $ackn4 $ackn5 $ackn6 $ackn7 $ackn8 $ackn9 $ackn10 $ackn11 $ackn12`
	zenity --title "$dialog_title" "$dialog_type" --text "$feedback"
	if [ "$?" == "0" ]; then
		echo "yes" > ~/.enc_dec_agreed
		$gui --title "Enabled!" "--info" --text "Secure file deletion is now active!  You may now re-launch the script!"
	else
		$gui --title "Disabled!" "--info" --text "Then you should disable secure file deletion before using this script again!"
	fi
	exit 0
fi

# Decrypt function
decrypt()
{
	# Collect GnuPG passphrase and decrypt the file
	getpasswd=`$gui  --title "GnuPG Decrypter" --entry --hide-text \
	--text="Please enter your GnuPG passphrase to decrypt $the_file:" \
	| sed 's/^[ \t]*//;s/[ \t]*$//'` &> /dev/null
	if [ "$getpasswd" == "" ]; then
		dialog_title="Operation Aborted!"
		dialog_type="--error"
		feedback="No passphrase submitted.  Operation cancelled!"
		feedback
		exit 0
	fi
	echo $getpasswd | $enc_dec -v --batch --passphrase-fd 0 --output /tmp/decrypted_output_file.dec \
	--decrypt "$files_path/$the_file" &> /tmp/encdecresult
	orig_filename=`cat /tmp/encdecresult | grep "original file name" | cut -d '=' -f2 | sed 's/'\''//g'`
	result=`cat /tmp/encdecresult | sed 's/<//g;s/>//g' | uniq`
	rm -f /tmp/encdecresult

	# Check for existence of decrypted file with same name
	if [[ -a "$files_path/$orig_filename" && `echo "$result" | grep "failed:"` == "" ]]; then
		dialog_title="Confirm File Replace!"
		dialog_type="--question"
		feedback="Decrypted file for $the_file already exists!  Overwrite it?"
		feedback
		if [ "$yesorno" == "1" ]; then
			dialog_title="Operation Aborted!"
			dialog_type="--info"
			feedback="Cancelled!"
			feedback
			$secure_delete -q -f /tmp/decrypted_output_file.dec
			exit 0
		else
			$secure_delete -q -f "$files_path/$orig_filename"
			if [ -a "$files_path/$orig_filename" ]; then
				dialog_title="Operation Aborted!"
				dialog_type="--error"
				feedback="$orig_filename could NOT be overwritten!"
				feedback
				exit 0
			fi
		fi
	fi
	cp /tmp/decrypted_output_file.dec "$files_path/$orig_filename"
	$secure_delete -q -f /tmp/decrypted_output_file.dec
	# Remove encrypted file after decryption (if configured to do so)
	if [[ "$rm_cyphertext_file" == "yes" && `echo "$result" | grep "failed:"` == "" ]]; then
		# Check for existence of the newly decrypted file before we remove the encrypted one
		if [ -a "$files_path/$orig_filename" ]; then
			rm -f "$files_path/$the_file"
			# Verify that the encrypted file was successfully removed
			if [ -a "$files_path/$the_file" ]; then
				result=`echo "$result - *NOTE* $the_file (the original file) could NOT be deleted!"`
			fi
		fi
	fi

	# User feedback
	if [[ `echo "$result" | grep "failed:"` != "" ]]; then
		dialog_title="Decryption Error!"
		dialog_type="--error"
		feedback=$result
		feedback
	else
		dialog_title="Decryption Results"
		dialog_type="--info"
		if [ "$verbose" == "yes" ]; then
			feedback="Success! - $the_file was decrypted to $orig_filename - $result"
		else
			feedback="Success! - Success! - $result"
		fi
		feedback
	fi
}

# Encrypt function
encrypt()
{
	# Check for existence of encrypted file with same name
	if [ -a "$files_path/$the_file.gpg" ]; then
		dialog_title="Confirm File Replace!"
		dialog_type="--question"
		feedback="Encrypted file for $the_file already exists!  Overwrite it?"
		feedback
		if [ "$yesorno" == "1" ]; then
			dialog_title="Operation Aborted!"
			dialog_type="--info"
			feedback="Cancelled!"
			feedback
			exit 0
		else
			rm -f "$files_path/$the_file.gpg"
			if [ -a "$files_path/$the_file.gpg" ]; then
				dialog_title="Operation Aborted!"
				dialog_type="--error"
				feedback="$the_file.gpg could NOT be overwritten!"
				feedback
				exit 0
			fi
		fi
	fi
	$enc_dec -v --batch --default-recipient-self -e "$files_path/$the_file" &> /tmp/encdecresult
	result=`cat /tmp/encdecresult`
	rm -f /tmp/encdecresult
	result=`echo $result | tail -n 1 | cut -d '"' -f2 | sed 's/<//g;s/>//g'`

	# Secure deletion of cleartext file (if configured to do so)
	if [[ "$rm_cleartext_file" == "yes" && `echo "$result" | grep "encryption failed"` == "" ]]; then
		sec_file_del
	else
		if [[ `echo "$result" | grep "failed:"` == "" ]]; then
			if [ "$verbose" == "yes" ]; then
				warn1="*WARNING* Although $the_file was encrypted to $the_file.gpg,"
				warn2="the original file was NOT deleted.  It is still on your drive!"
				warn3="This may be a security issue!  Consider enabling secure file"
				warn4="deletion.  To stop seeing this warning, you can set the verbose"
				warn5="option to, 'no' near the top of the script."
				result=`echo "$result - $warn1 $warn2 $warn3 $warn4 $warn5"`
			fi
		fi
	fi

	# User feedback
	if [[ `echo "$result" | grep "failed:"` != "" ]]; then
		dialog_title="Encryption Error!"
		dialog_type="--error"
		feedback=$result
		feedback
	else
		dialog_title="Encryption Results"
		dialog_type="--info"
		if [ "$verbose" == "yes" ]; then
			feedback="Success! - $the_file was encrypted to $the_file.gpg using key $result"
		else
			feedback="Success! - Encrypted to $the_file.gpg."
		fi
		feedback
	fi
}

# Secure file deletion function
sec_file_del()
{
	# Check for secure file deletion utility
	if [ -x "$secure_delete" ]; then
		# Check for existence of the newly encrypted file before we remove the original
		if [ -a "$files_path/$the_file.gpg" ]; then
			$secure_delete -q -f "$files_path/$the_file"
			if [ -a "$files_path/$the_file" ]; then
				result=`echo "$result - *NOTE* $the_file (the original file) could NOT be securely deleted!"`
			else
				result=`echo "$result - *NOTE* $the_file (the original file) was securely deleted!"`
			fi
		fi
	else
		warn1="*WARNING* $the_file could NOT be securely deleted!"
		warn2="Make sure you have installed the wipe utility."
		warn3="(ex: 'sudo apt-get install wipe')"
		result=`echo "$result - $warn1 $warn2 $warn3"`
	fi
}

# Feedback function
feedback()
{
	$gui  --title "$dialog_title" $dialog_type --text="$feedback"
	yesorno=$?
}

# Errors function
errors()
{
	if [ -x "$gui" ]; then
		result=""
	else
		result="Zenity NOT found.  This utility is required!; "
	fi
	if [ -x "$enc_dec" ]; then
		result=`echo "$result"`
	else
		result=`echo "$result GnuPG NOT found.  This utility is required!; "`
	fi
	if [ -x "$secure_delete" ]; then
		result=`echo "$result"`
	else
		result=`echo "$result 'wipe' command line utility NOT found.  This utility is required!"`
	fi
	echo $result
	dialog_title="Missing Required Tools!"
	dialog_type="--error"
	feedback=$result
	feedback
	exit 1
}

# Check for required tools
if [[ -x "$gui" && -x "$enc_dec" && -x "$secure_delete" ]]; then
	if [[ "$the_file" =~ "\.gpg$" || "$1" =~ "\.pgp$" ]]; then
		decrypt
	else
		encrypt
	fi
else
	errors
fi
exit 0
