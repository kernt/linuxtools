#!/bin/bash
# A very simple script used to create users on a CentOS machine interactively
# It is assumed that you will be using the root account for this task
# But you can comment the line with the check if you are using sudo
#

# Copyright (c) 2010 Lethe's Tuxforge <http://blog.tuxforge.com>
# This script is licensed under GNU GPL version 2.0 or above

if [ $(id -u) -eq 0 ]; then                             #Überprüft ob auch Root Rechte vorhanden sind
 read -p "Enter username : " username
 
 egrep "^$username" /etc/passwd >/dev/null
 if [ $? -eq 0 ]; then
 echo "Der Benutzer : $username existiert bereits! Bitte einen anderen Benutzeranmen wählen." #Exit if user already exists
 exit 1
 else
 read -s -p "Password eingebn : " password
 echo  "Enter the  expiration date in the format YYYY/MM/DD : "
 read  expiration
 pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
 useradd -m -s /bin/bash -e $expiration -g ftpusers -d /home/$username  -p $pass $username
 [ $? -eq 0 ] && echo "User has been added to system!" && chage -l $username || echo "Failed to add a user!" #We create the user and print on screen expiration parameters
 fi
else
 echo "You need to be root or use sudo to add users to the system!"
 exit 2
fi
