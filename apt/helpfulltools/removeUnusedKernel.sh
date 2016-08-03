#!/bin/bash
#
# Script-Name : removeUnusedKernel.sh
# Version : 0.01
# Autor : Tobias Kern
# Datum : 19.12.2014
# Lizenz : GPLv3
# Depends :
# Use :
#
# Example:
#
# Description:
###########################################################################################
## Deinstalled unused Kernels on Debian Linux.
##
###########################################################################################
sudo apt-get remove $(dpkg -l|awk '/^ii  linux-image-/{print $2}'|sed 's/linux-image-//'|awk -v v=`uname -r` 'v>$0'|sed 's/-generic*//'|awk '{printf("linux-headers-%s\nlinux-headers-%s-generic*\nlinux-image-%s-generic*\n",$0,$0,$0)}')
