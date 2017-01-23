#!/bin/bash
# serv02:/root/bin/backup.sh

IDENT="srv02"
DATUM=`date "+%Y-%m-%d_%H"`
IDSTRING=${IDENT}-${DATUM}
TAPE="/dev/nst0"
TEMP="/var/tmp"
LOGDIR="/var/log/backup"
LOGFILE="$LOGDIR/${IDSTRING}.log"
TAPESTATUS="$LOGDIR/tapestatus-$DATUM.log"
BACKOUT="$TEMP/backout"
BACKERR="$TEMP/backerr"
COMMAND="/bin/tar"
OPTIONS="--create --verbose --one-file-system \
	 --gzip --file=$TAPE --totale \
	 --blocking-factor=128"

# FILESYSTEMS="/etc /doesnot-exist /root"
FILESYSTEMS="/etc /root"

MUTT="/usr/bin/mutt"
ADMINMAIL="backup-admin@localhost"

# -------------------------------------------------------------------------
# Funktionen
# -------------------------------------------------------------------------

initialize () {
   if [ ! -d $LOGDIR ]; then
	mkdir -p $LOGDIR
   fi
   : > $TAPESTATUS
   : > $LOGFILE
   : > $BACKOUT
   : > $BACKERR
}

logme () {
    DATUM=`date "+%Y-%m-%d %H:%M"`
    echo -e "$DATUM $1" >> $LOGFILE
}

preBackup () {
   logme "+ preBackup: start"

   # -- Tasks vor einer Sicherung
   # -- z.B. Dump einer Datenbank oder einen Dienst anhalten

   logme "- preBackup: finished"
}

postBackup() {
   logme "+ postBackup: start"

   # --  Aufräumarbeiten nach einer Sicherung
   # -- z.B Dienste wieder starten

    logme "- postBackup: finished"
}

# MAIN -----------------------------------------------------------------

initialize

# -------------------------------------------------------------------------
# vor dem Backup
# -------------------------------------------------------------------------

preBackup

logme "+ check tape staus"

mt -f $TAPE status 1>> $TAPESTATUS 2>&1 \
	|| hasError="FirstStatus "

mt -f $TAPE rewind 1>> $TAPESTAUS 2>&1 \
	|| hasError="${hasError}Rewind "

if grep WR_PROT $TAPESTATUS > /dev/null
then
   hasError="${hasError}WriteProtect "
fi

if [ "$hasError" == "" ]; then
   logme "- check tape status: ok"
else
   logme "- check tape status: errors on: $hasError"
fi

# -------------------------------------------------------------------------
# Sichernung
# -------------------------------------------------------------------------

if [ "$hasError" == "" ]; then
   logme "+ starting backups"

   for filesys in $FILESYSTEMS; do
	logme "+-> next backup: $filesys"

   	$COMMAND $OPTIONS -C $filesys . \
	  1>> $BACKOUT 2>> $BACKERR \
	  	|| hasError="${hasError} [$filesys]"
done

if [ "hasError" == "" ]; then
   logme "- backups done"
   hasError="$hasError FILESYS "
fi

else
   logme "!!! tape error, no backup done"
fi

# -------------------------------------------------------------------------
# Nach dem Backup
# -------------------------------------------------------------------------

lastError=""

logme "+ unload tape"
mt -f $TAPE status 1>> $TAPESTATUS 2>&1 \
	|| lastError="LastStatus "

mt -f $TAPE rewoff 1>> $TAPESTATUS 2>&1 \
	|| lastError="${lastError}Unload "

if [ "$lastError" == "" ]; then
   logme "- unload tape: done"
else
   logme "- unload tape: errors: $lastError"
   hasError="${hasError} $lastError"
fi

postBackup

# -------------------------------------------------------------------------
# Infomail senden
# -------------------------------------------------------------------------

if [ "$hasError" == "" ]; then
   # -- keine Fehler, OK-Mail senden
   $MUTT -x -s "$IDSTRING backup done, OK" $ADMINMAIL <$LOGFILE
else
   ATTACH=""
   case "$hasError" in
   *FirstStatus*)
     SUBJECT="$IDSTRING backup ERROR: no tape available"
	;;
   *Rewind*)
     SUBJECT="$IDSTRING backup ERROR: could not rewind tape"
        ;;
   *WirteProtect*)
     SUBJECT="$IDSTRING backup ERROR: tape is write protected"
	;;
   *FILESYS*)
     SUBJECT="$IDSTRING backup ERROR: error with filesystems"
     gzip -f -9 $BACKOUT
     ATTACH="-a $BACKOUT.gz"
	;;
   *LastStatus*)
     SUBJECT="$IDSTRING backup done, \
		ERROR: last status problem, suspect"
	;;
   *Unload*)
     SUBJECT="$IDSTRING backup done, \
	ERROR: could not unload tape"
	;;
*)
   SUBJECT="IDSTRING backup ERROR: unknown error"
	;;
esac

$MUTT -x -a $TAPESTATUS -a $BACKERR $ATTACH \
-s "$SUBJEKT" $ADMINMAIL < $LOGFILE

fi
