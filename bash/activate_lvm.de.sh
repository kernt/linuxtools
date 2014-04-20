#!/usr/bin/env bash
#
# Script-Name : activate_lvm.de.sh
# Version     : $VERSION
# Autor       : $AUTUR
# Datum       : 
# Lizenz      : GPLv3
# Depends     : lvm2
# Use         : execute only
#
# Description:
###########################################################################################
## 
##
###########################################################################################
# Lvm durchsuchen und aktiviren
# Gegenenfales LVM Installation
# apt-get install lvm2
# Nach Pysikalichen Geräten suchen
pvscan
#Volume Grupe finden und aktiviren
vgchange -a y
#Lokale Volumes erkenn , werden automatisch aktivirt.
lvscan
# mount /dev/VolGroup00/LogVol00 /mnt

exit 0
