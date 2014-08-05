#/bin/bash
#
#
# Source:
#
MYHOST="$1:192.168.1.1"
touch ~/.ssh/host_colors
echo "$MYHOST 0x990000 0xffffff" >> ~/.ssh/host_colors

if [ ! -f ~/.bash_aliases] ; then
  touch  ~/.bash_aliases
fi
