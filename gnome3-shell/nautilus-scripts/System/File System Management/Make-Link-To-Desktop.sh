#!/bin/bash
#
#  Send to Desktop - Create Symlink
#
#  Project: http://www.g-loaded.eu/2008/11/03/send-to-desktop-create-symlink/
#
#  Features:
#      - creates symlinks on the desktop pointing to each of the selected items
#        (files/directories).
#      - Supports paths containing spaces.
#      - Supports multi-selection (warns before creating multiple symlinks)
#
#  Requires:
#      - ln
#      - zenity
#
#  Installation:
#  1) Put the file in ~/.gnome2/nautilus-scripts/
#       cp "Send to Desktop - Create Symlink" ~/.gnome2/nautilus-scripts/
#  2) Set the 'executable' bit:
#       chmod -x ~/.gnome2/nautilus-scripts/"Send to Desktop - Create Symlink"
#  3) Access the script by right clicking and selecting the submenu 'scripts'
#
#  Copyright 2008 George Notaras &lt;gnot [at] g-loaded.eu&gt;, CodeTRAX.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

DESKTOP=~/Desktop

if [ $# -lt 1 ] ; then
  zenity --error --text "At least one file or directory must be selected."
elif [ $# -gt 1 ] ; then
  zenity --question --text "Multiple items selected. Proceed?"
fi

if [ "$?" = 1 ] ; then
    exit 1
fi

for item in "$@"; do
    ln -s "$PWD/$item" "$DESKTOP/$item"
done

exit 0
