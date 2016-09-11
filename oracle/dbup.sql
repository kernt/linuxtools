#! /bin/ksh

# -----------------------------------------------------------------------
# Filename:   dbup.ksh
# Purpose:    Check if DB's background processes are started
# Author:     Frank Naude, Oracle FAQ
# -----------------------------------------------------------------------

HELP=0; VERBOSE=0
while getopts hv KEY $*
do
	case $KEY in
	v)	VERBOSE=1;;
	*)	HELP=1;;
	esac
done

if [ ${HELP} -eq "1" -o ${#} -eq "0" ] ; then
  cat 1>&2 <<EOF

Usage: dbup [-h] [-v] ORACLE_SID [ORACLE_SID2...]

  where   -h gives this help
          -v verbose 

This command checks if a set of databases is started or not. It can be used to 
check database availability before serious work is atempted.

Returns -1 is one of the databases is not running, otherwise 0.

EOF
  exit
fi
shift OPTIND-1

FAILED=0; INSTANCEDOWN=0 
for INSTANCE in $*
do
        if [ ${VERBOSE} -eq "1" ] ; then
	   echo "Checking instance ${INSTANCE}...\n" 
        fi
	for PROCESS in pmon smon 
	do
	  RC=$(ps -ef | egrep ${INSTANCE} | egrep -v 'grep' | egrep ${PROCESS}) 
	  if [ "${RC}" = "" ] ; then
	    INSTANCEDOWN=1 
            if [ ${VERBOSE} -eq "1" ] ; then
	       echo "\tERROR: Instance ${INSTANCE} ${PROCESS} down!" 
            fi
	  fi 
	done
        if [ ${INSTANCEDOWN} = "1" ] ; then
	   echo "`date` - Instance ${INSTANCE} is DOWN!!!\n" 
	   FAILED=1
	else 
	   echo "`date` - Instance ${INSTANCE} is running.\n" 
	fi	
done

if [ ${FAILED} = "1" ] ; then
  return -1
else
  return 0
fi
