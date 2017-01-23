#!/bin/bash
#
# scriptbuilder.sh v0.1 Build on the 2012-01-10 #
# (C)opyright 2011 - mpingu #
#Important---------------------------------------------------#
# By running this, YOU are using this program at YOUR OWN RISK. #
# This software is provided "as is", WITHOUT ANY guarantees OR warranty. 
#
#License----------------------------------------------#
# This program is free software: 
# you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published
# by the Free Software Foundation, either #
# version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY;
# without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <http://www.gnu.org/licenses/>. #
#----------------------
# Variables

# Functions 
#-----------------------

function show_info() {
echo "Shellscript Builder v 0.01 by Mpingu"
echo "https://mpingu@github.com/mpingu/shellscriptbuilder"
echo "(C)opyright 2012 mpingu http://www.secured-penguin.de"
}

function set_scriptname () {
read -p "Enter Scriptname" scriptname
echo " "
}

function help() {
echo "Menudriven creation for basic emtpy shellscripts"
echo "You can choose between diffrent Licences and menu templates"
echo "Follow the on-screen instructions"
show_info
}

function write_script(){
while read line;
 do
   echo $line >> "$scriptname".sh
 done < templates/"$1".txt
}	

function menu_license() {
show_info
echo "Select licenses to use"
echo "Look Inside "$licensename".txt to edit them"	
echo "["$s"G"$n"]PL V3"
echo "["$s"H"$n"]elp"
echo "E["$s"X"$n"]it"

while true; do
echo -ne "\e[00;33m[~]\e[00m "; read -p "Select your License:"
if [[ "$REPLY" =~ ^[Gg]$ ]]; then mode="license_GPL"; break
 elif [[ "$REPLY" =~ ^[Hh]$ ]]; then help
  elif [[ "$REPLY" =~ ^[Xx]$ ]]; then exit
fi
done;
}

function menu_main() {
show_info
echo "["$s"S"$n"]tart building Script"
echo "["$s"H"$n"]elp"
echo "E["$s"X"$n"]it"

while true; do
 echo -ne "\e[00;33m[~]\e[00m "; read -p "Start building your script: "
 if [[ "$REPLY" =~ ^[Ss]$ ]]; then mode="menu_license"; break
  elif [[ "$REPLY" =~ ^[Hh]$ ]]; then help
  elif [[ "$REPLY" =~ ^[Xx]$ ]]; then exit
 fi
done;
}

main() {
if [ -z "$scriptname" ] ||[ "$scriptname" == " " ]; then
 set_scriptname
fi

if [ -z "$mode" ] || [ "$mode" == " " ]; then
 menu_main;
fi
#mode menu_license
if [ "$mode" == "menu_licenses" ]; then
	menu_license;
fi
#license fallback
if [ -z "$license" ] || [ "$license" == " " ]; then
	menu_license;
fi
#mode GPL
if [ "$mode" == "license_GPL" ]; then
	license=GPL
fi

function script_content() {
write_script header
write_script $license
write_script variables
write_script functions
write_script menu
write_script main
}
script_content
}

#------------------------------------------------------------#
# Main #
main
