rem -----------------------------------------------------------------------
rem Filename:   rman_run.sql
rem Purpose:    Monitor RMAN status, while a backup is running
rem Date:	12-Nov-1999
rem Author:     Frank Naude, Oracle FAQ
rem -----------------------------------------------------------------------

prompt RMAN Backup Status:

SELECT to_char(start_time,'DD-MON-YY HH24:MI') "BACKUP STARTED",
       sofar, totalwork,
       elapsed_seconds/60 "ELAPSE (Min)",
       round(sofar/totalwork*100,2) "Complete%"
FROM   sys.v_$session_longops
WHERE  compnam = 'dbms_backup_restore'
/
