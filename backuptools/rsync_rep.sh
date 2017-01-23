#!/bin/bash
# Remote Server Rsync backup Replication Shell Script
# ------------------------------
# Copyright (c) 2005 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# --------------------------------
# Local dir location
LOCALBAKPOINT=/disk3
LOCALBAKDIR=/remote/home/httpd/
# remote ssh server
# user
SSHUER=brootbeer

# server IP / host
SSHSERVER=10.10.11.12

#remote dir to backup
SSHBACKUPROOT=/disk2.backup/hot/

rsync --exclude '*access.log*' --exclude '*error.log*' -avz -e 'ssh ' ${SSHUER}@${SSHSERVER}:${SSHBACKUPROOT} ${LOCALBAKPOINT}${LOCALBAKDIR}

# log if backup failed or not to /var/log/messages file
[ $? -eq 0 ] && logger 'RSYNC BACKUP : Done' || logger 'RSYNC BACKUP : FAILED!'

# Replicate backup to /disk1 and /disk2
# You can also use format user@host:/path
# refer to rsync man page
SRC=${LOCALBAKPOINT}${LOCALBAKDIR}
DST="/disk1/remote /disk2/remote"
for d in $DST
  do
   [ ! -d $d ] && mkdir -p $d || :
    rsync -avr $SRC $d
  done
