rem -----------------------------------------------------------------------
rem Filename:   rmanlist.sql
rem Purpose:    List backups registered in RMAN catalog database
rem Author:     Frank Naude, Oracle FAQ
rem -----------------------------------------------------------------------

connect rman/rman

col media   format a8
col tag     format a12 trunc
col minutes format 990

select d.name, p.tag, p.media,
       s.incremental_level "LEVEL",
       to_char(s.start_time, 'DD-MON-YY HH24:MI') start_time,
       s.elapsed_seconds/60 "MINUTES"
from  RC_DATABASE d, RC_BACKUP_PIECE p, RC_BACKUP_SET s
where d.name            = 'WH'
  and s.start_time      > '04-MAY-02'
  and s.completion_time < '06-MAY-02'
  and p.backup_type     = 'D' -- D=Database, L=Log
  and d.db_key = p.db_key
  and s.db_key = p.db_key
  and p.bs_key = s.bs_key
/
