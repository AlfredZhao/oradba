-- Interactive entry point. It deliberately stays in one SQLcl process.
@@lib/bootstrap.sql &1 &2

-- Session-only shortcuts. Parameterised operations remain shell commands so
-- bin/oradba can validate their arguments before SQLcl receives them.
alias -silent ora_env=q'
@&3/realtime/environment.sql
'
/
alias -silent ora_tablespaces=q'
@&3/basic/tablespace_usage.sql
'
/
alias -silent ora_sessions=q'
@&3/realtime/active_sessions.sql
'
/
alias -silent ora_longops=q'
@&3/realtime/longops.sql
'
/
alias -silent ora_blocking=q'
@&3/realtime/blocking_sessions.sql
'
/
alias -silent ora_awr_snapshots=q'
@&3/awr/list_snapshots.sql
'
/
prompt
prompt oradba SQLcl session is ready. Type one of:
prompt   ora_env | ora_tablespaces | ora_sessions | ora_longops | ora_blocking
prompt   ora_awr_snapshots          (SQLcl native: awr list snapshots)
prompt   awr create html <begin_snap> <end_snap>
prompt
prompt For validated parameterised commands, from another shell use:
prompt   bin/oradba sql-id <SQL_ID> [DAYS]
prompt   bin/oradba ash-top-waits [HOURS]
prompt   bin/oradba awr-report <BEGIN_SNAP> <END_SNAP>
prompt
