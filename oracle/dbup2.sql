#!/bin/ksh
# -----------------------------------------------------------------------
# Filename:   dbup
# Purpose:    Connect to databases via listeners to measure uptime and to
#             ensure that users can connect via the listeners
# Return:     0 = success, 1 = something wrong (errors goes to log file)
# Author:     Frank Naude
# Date:       27 September 2000
# Revised:    14 July 2006
#-----------------------------------------------------------------------

# Connect string to use when connecting to Oracle database
CONNSTR=monitor/monitor

# NODE=`hostname` works for most hosts
# Hard code for floating hostnames eg. tcen-mast-int
NODE=`hostname`

# Format of TNSNAMES entries. Valid values: NODE, DB or NODE_DB
TNSFORMAT="NODE_DB"

# Databases to check. Change if you need to exclude certain databases.
# Eg: DBMASK='^prd.*:.*:[NnYy]$' gives DBs with names starting with "prd"
DBMASK='^.*:.*:[Yy]$'

# Connect timeout in seconds
CONNTIMEOUT=60

# Write error messages to this log file
LOGFILE=/tmp/dbup

# -----------------------------------------------------------------------
# Please do not change anything below this line
# -----------------------------------------------------------------------

# Locate the correct ORATAB file
if [ -f /etc/oratab ]; then
   ORATAB=/etc/oratab
elif [ -f /var/opt/oracle/oratab ]; then
   ORATAB=/var/opt/oracle/oratab
else
   print "ERROR: Unable to locate ORATAB file" >>${LOGFILE}
   exit -1
fi

# Locate the correct TNSNAMES.ORA file
if [ -f /etc/tnsnames.ora ]; then
   TNSNAMES=/etc/tnsnames.ora
elif [ -f /var/opt/oracle/tnsnames.ora ]; then
   TNSNAMES=/var/opt/oracle/tnsnames.ora
fi

ALL_DATABASES=`cat ${ORATAB} | grep -v "^#" | grep ${DBMASK} | cut -f1
-d: -s`

for DB in ${ALL_DATABASES}
do
   unset  TWO_TASK
   export ORACLE_SID=$DB
   export ORACLE_HOME=`grep "^${DB}:" ${ORATAB}|cut -d: -f2 -s`
   export PATH=$ORACLE_HOME/bin:$PATH
   export LD_LIBRARY_PATH=$ORACLE_HOME/lib
   export SHLIB_PATH=$ORACLE_HOME/lib

   # Skip non database home $ORACLE_HOME
   if [ ! -x $ORACLE_HOME/bin/oracle ]; then
      print "`date`: Skip non database home ${ORACLE_HOME}" >>${LOGFILE}
      continue
   fi
   # SQL*Plus not available in $ORACLE_HOME
   if [ ! -x $ORACLE_HOME/bin/sqlplus ]; then
      print "`date`: SQL*Plus not available in ${ORACLE_HOME}" >>${LOGFILE}
      continue
   fi

   if [ "${TNSFORMAT}" = "DB" ]; then
      NETNAME="${DB}"
   elif [ "${TNSFORMAT}" = "NODE" ]; then
      NETNAME="${NODE}"
   elif [ "${TNSFORMAT}" = "NODE_DB" ]; then
      NETNAME="${NODE}_${DB}"
   else
      print "ERROR: Invalid TNSFORMAT value used" >>${LOGFILE}
      exit -1
   fi

   # Open pipe to Oracle sqlplus
   sqlplus -s /nolog |&

   # Set connection timeout timer
   OUT=""
   PID=$!
   sleep ${CONNTIMEOUT} | (
        read nothing                         # wait on sleep to finish
        kill -0 ${PID} 2>/dev/null || exit;  # exit if finished
        print "`date`: SQL*Plus was hanging - Killed" >>${LOGFILE}
        kill -9 ${PID} 2>/dev/null           # kill it!!!
   ) &

   # Connect to database
   print -p "whenever sqlerror exit"
   print -p "connect ${CONNSTR}@${NETNAME}"
   print -p "prompt Connected."
   read  -p OUT
   # print -p "exit 0" 2>/dev/null

   # Remove empty lines from output
   ((i=0))
   while [ "${OUT}" = "" -a "${i}" -lt "5" ]; do
      read -p OUT 2>/dev/null
      ((i=i+1))
   done

   # Check connection status
   if [ "${OUT}" = "Connected." ]; then
      print "${NETNAME} 1"
      print "`date`: Successfully connected to ${NETNAME}" >>${LOGFILE}
   elif [ "${OUT}" = "" ]; then
      print "${NETNAME} 0"
      print "`date`: Unable to connect to ${NETNAME}" >>${LOGFILE}
      print "`date`: Connection is hanging - timed out!!!" >>${LOGFILE}
      # -- Add commands for SMS, EMail escalations here --
   else
      print "${NETNAME} 0"
      print "`date`: Unable to connect to ${NETNAME}" >>${LOGFILE}
      print "`date`: ${OUT}"                          >>${LOGFILE}
      read  -p OUT 2>/dev/null
      print "`date`: ${OUT}"                          >>${LOGFILE}
      # -- Add commands for SMS, EMail escalations here --
   fi

   print -p "exit 0" 2>/dev/null
   exec 3>&p            # Close co-processes' file descriptors
   kill -9 ${PID}    2>/dev/null
   wait ${PID}       2>/dev/null

Done

######### Last Statement of: dbup.ksh #########
