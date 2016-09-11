#!/usr/bin/ksh

#------------------------------------------------------------------------------------------------
usage()
#------------------------------------------------------------------------------------------------
{
cat <<END

Filename    : dba_alertlog.ksh
Version     : 1.0
Summary     : Print alertlog messages with date/time stamp on the same line.
            : Default alertlog entries have a date, and then the message on the next line.

Parameters  : Mandatory:
            :   No parameters are mandatory.  
            :   If no parameters are supplied then the alert log for the current ORACLE_SID will 
            :   be displayed.
            : Optional:
            :   Filename(s) of the alertlogs to be processed.

Calls       : No other scripts

Date       Author   Version
20-Aug-04  ASBlack  1.0       Created.  

NOTES:
1) This script is self documented.  To get a program flow execute:
     grep "#-- " dba_alertlog.ksh

EXAMPLES:
1) dba_alertlog.ksh
This will display the contents of the current alert log for the ORACLE_SID that is currently set

2) dba_alertlog.ksh alert_somesid.log.2004*
This will display the contents of all alert logs that have are named alertsomesid.log.2004*
which can be produced if automated housekeeping of the alertlogs has been implemented to "roll
over" alertlogs daily or weekly ...

END
}

#------------------------------------------------------------------------------------------------
# MAIN PROGRAM STARTS HERE
#------------------------------------------------------------------------------------------------

#-- Display usage if requested
if [[ ${1} = "help" ]]; then usage; exit 0; fi

#-- Set variables
PRG=`basename $0`
LOGFILES=""
CMD=""

#-- Get command line parameters
if [ $# -ne 0 ]; then LOGFILES=$@; fi

#-- Echo start time and command
date +"%Y/%m/%d %H:%M:$S Started ${PRG} ${PARAMETERS}"
echo

#-- Determine the location of the alert log if not specified
if [ -z "${LOGFILES}" ]; then

  #-- Determine the ORACLE_HOME
  ORAHOME=""
  ORAHOME=`grep -h "^${ORACLE_SID}:" /var/opt/oracle/oratab /etc/oratab 2>/dev/null |head -1 |awk -F":" '{print $2}'`
  if [[ -z "${ORAHOME}" ]]; then
    echo "ERROR: Cannot determine ORACLE_HOME for ${ORACLE_SID} ..."
    exit 10
  fi

  #-- Determine if there is an spfile
  SPFILE=${ORAHOME}/dbs/spfile${ORACLE_SID}.ora

  #-- If there isn't an spfile then use the init.ora file
  if [[ ! -f ${SPFILE} ]]; then

    #-- Determine where the init.ora file is
    INITORA=${ORAHOME}/dbs/init${ORACLE_SID}.ora
    echo INITORA = ${INITORA}

    #-- Determine if there is an ifile
    IFILE=`egrep -i "ifile|spfile" ${INITORA} |grep -v "^#" |head -1 |awk -F"=" '{print $2}' |sed -e 's/[      ]//g' -e "s/'//g"`
    echo IFILE = ${IFILE}
  fi

  #-- Determine what background_dump_dest is set to in the init.ora file
  #   (It defaults to ?/rdbms/log within the database if it's not in the init.ora file)
  BACKGROUND_DUMP_DEST=`grep -i "background_dump_dest" ${SPFILE} ${INITORA} ${IFILE} 2>/dev/null |grep -v "^#" |head -1 |awk -F"=" '{print $2}' |sed -e 's/[       ][      ]*//g' -e "s/'//g"`
  if [ -z "${BACKGROUND_DUMP_DEST}" ]; then
    BACKGROUND_DUMP_DEST=${ORACLE_HOME}/rdbms/log
  fi

  #-- Ensure that $ORACLE_HOME is expanded out 
  #   This fixes a strange bug when running remotely, and 
  #   background_dump_dest contains string: $ORACLE_HOME
  eval BACKGROUND_DUMP_DEST=`echo ${BACKGROUND_DUMP_DEST} |sed -e "s+\$ORACLE_HOME+${ORAHOME}+"`

  #-- Determine where the alertlog file is 
  LOGFILES=${BACKGROUND_DUMP_DEST}/alert_${ORACLE_SID}.log

fi

#-- Check the log file(s) exist and are readable
for FILE in ${LOGFILES}
do
  
  #-- Check that the file exist and is readable
  if [ ! -r "${FILE}" ]; then
    echo
    date +"%Y/%m/%d %H:%M:%S ERROR: Log ${FILE} does not exist or is not readable"
    echo
    break
  fi

  #-- List alertlog for reference
  echo
  date +"%Y/%m/%d %H:%M:%S Processing alertlog ${FILE}"
  ls -l ${FILE} 
  echo
  
  #-- Get the command to send the alertlog to stdout
  if   [ `echo ${FILE} |grep -c ".gz$"` -eq 1 ]; then
    CMD="gzip -dc ${FILE}"
  elif [ `echo ${FILE} |grep -c ".Z$"` -eq 1 ]; then
    CMD="zcat ${FILE}"
  else
    CMD="cat ${FILE}"
  fi

  #-- Print out the alert log with time stamps at the start of each record
  #-- Note that date's in the alert log have the format:
  #--   Fri Aug 16 12:52:55 2002
  echo ${CMD} |ksh \
    |awk '{
  
  if($1=="Mon" || $1=="Tue" || $1=="Wed" || $1=="Thu" || $1=="Fri" || $1=="Sat" || $1=="Sun")
   {
    DAY=$1
    TIME=$4
    YEAR=$5
  
    DATE=$3
    if(length(DATE)==1){DATE="0"DATE}

    if($2=="Jan"){MONTH="01"}
    if($2=="Feb"){MONTH="02"}
    if($2=="Mar"){MONTH="03"}
    if($2=="Apr"){MONTH="04"}
    if($2=="May"){MONTH="05"}
    if($2=="Jun"){MONTH="06"}
    if($2=="Jul"){MONTH="07"}
    if($2=="Aug"){MONTH="08"}
    if($2=="Sep"){MONTH="09"}
    if($2=="Oct"){MONTH="10"}
    if($2=="Nov"){MONTH="11"}
    if($2=="Dec"){MONTH="12"}
  
   }
  else
   { 
    print YEAR"/"MONTH"/"DATE" "DAY" "TIME" "$0 
   }
  }'

done # End of loop for FILE
