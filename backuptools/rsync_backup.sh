#!/bin/bash
#
#
# Simple backup with rsync (version 2011-03-10)
# 
# local-mode, tossh-mode, fromssh-mode

# sources and target MUST end WITH slash
SOURCES="/root/ /etc/ /home/ /lib/ /bin/ /sbin/ /mnt/ /media/ /srv/"
TARGET="/media/backup/"

RSYNCCONF="--delete"

#MOUNTPOINT="/media/backup"     # mountpoint must end WITHOUT slash
PACKAGES=0	
MONTHROTATE=1
MAILREC="tobkern1980@googlemail.com"

#SSHUSER="root"
#SSHPORT=22 
#FROMSSH="clientsystem"
#TOSSH="backupserver"

### do not edit ###

MOUNT="/bin/mount"; FGREP="/bin/fgrep"; SSH="/usr/bin/ssh"
LN="/bin/ln"; ECHO="/bin/echo"; DATE="/bin/date"; RM="/bin/rm"
DPKG="/usr/bin/dpkg"; AWK="/usr/bin/awk"; MAIL="/usr/bin/mail"
CUT="/usr/bin/cut"; TR="/usr/bin/tr"; RSYNC="/usr/bin/rsync"
LAST="last"; INC="--link-dest=../$LAST"

# a new way to set binary tools in Linux environment
# added on 2014 Juli  27
#MOUNT=$(type -p mount)
#FGREP=$(type -p fgrep)
#SSH=$(ssh)
#LN=$(ln)
#ECHO=$(type -p echo)
#DATE=$(type -p dates)
#RM=$(type -p rm)
#DPKG=$(type -p dpkg)
#AWK=$(


LOG=$0.log
$DATE > $LOG

if [ $PACKAGES -eq 1 ] && [ -z "$FROMSSH" ]; then
  $ECHO "$DPKG --get-selections | $AWK '!/deinstall|purge|hold/'|$CUT -f1 | $TR '\n' ' '" >> $LOG
  $DPKG --get-selections | $AWK '!/deinstall|purge|hold/'|$CUT -f1 |$TR '\n' ' '  >> $LOG  2>&1 
fi

MOUNTED=$($MOUNT | $FGREP "$MOUNTPOINT");
if [ -z "$MOUNTPOINT" ] || [ -n "$MOUNTED" ]; then
  if [ $MONTHROTATE -eq 1 ]; then
    TODAY=$($DATE +%d)
  else
    TODAY=$($DATE +%y%m%d)
  fi

  if [ "$SSHUSER" ] && [ "$SSHPORT" ]; then
    S="$SSH -p $SSHPORT -l $SSHUSER";
  fi

  for SOURCE in $($ECHO $SOURCES)
  do
    if [ "$S" ] && [ "$FROMSSH" ] && [ -z "$TOSSH" ]; then
      $ECHO "$RSYNC -e \"$S\" -avR $FROMSSH:$SOURCE $RSYNCCONF $TARGET$TODAY $INC"  >> $LOG 
      $RSYNC -e "$S" -avR $FROMSSH:$SOURCE $RSYNCCONF $TARGET$TODAY $INC >> $LOG 2>&1 
      if [ $? -ne 0 ]; then
        ERROR=1
      fi 
    fi 
    if [ "$S" ]  && [ "$TOSSH" ] && [ -z "$FROMSSH" ]; then
      $ECHO "$RSYNC -e \"$S\" -avR $SOURCE $RSYNCCONF $TOSSH:$TARGET$TODAY $INC " >> $LOG
      $RSYNC -e "$S" -avR $SOURCE $RSYNCCONF $TOSSH:$TARGET$TODAY $INC >> $LOG 2>&1 
      if [ $? -ne 0 ]; then
        ERROR=1
      fi 
    fi
    if [ -z "$S" ]; then
      $ECHO "$RSYNC -avR $SOURCE $RSYNCCONF $TARGET$TODAY $INC"  >> $LOG 
      $RSYNC -avR $SOURCE $RSYNCCONF $TARGET$TODAY $INC  >> $LOG 2>&1 
      if [ $? -ne 0 ]; then
        ERROR=1
      fi 
    fi
  done

  if [ "$S" ] && [ "$TOSSH" ] && [ -z "$FROMSSH" ]; then
    $ECHO "$SSH -p $SSHPORT -l $SSHUSER $TOSSH $LN -nsf $TARGET$TODAY $TARGET$LAST" >> $LOG  
    $SSH -p $SSHPORT -l $SSHUSER $TOSSH "$LN -nsf $TARGET$TODAY $TARGET$LAST" >> $LOG 2>&1
    if [ $? -ne 0 ]; then
      ERROR=1
    fi 
  fi 
  if ( [ "$S" ] && [ "$FROMSSH" ] && [ -z "$TOSSH" ] ) || ( [ -z "$S" ] );  then
    $ECHO "$LN -nsf $TARGET$TODAY $TARGET$LAST" >> $LOG
    $LN -nsf $TARGET$TODAY $TARGET$LAST  >> $LOG 2>&1 
    if [ $? -ne 0 ]; then
      ERROR=1
    fi 
  fi
else
   $ECHO "$MOUNTPOINT not mounted" >> $LOG
   ERROR=1
fi
$DATE >> $LOG
if [ -n "$MAILREC" ]; then
  if [ $ERROR ];then
    $MAIL -s "Error Backup $LOG" $MAILREC < $LOG
  else
    $MAIL -s "Backup $LOG" $MAILREC < $LOG
  fi
fi

