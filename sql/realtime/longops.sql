column opname format a42
column target format a30
column progress format a11
select inst_id, sid, serial#, username, opname, target,
       round(sofar / nullif(totalwork, 0) * 100, 1) || '%' as progress,
       elapsed_seconds, time_remaining, sql_id
from gv$session_longops
where totalwork > 0
  and sofar < totalwork
  and time_remaining > 0
order by time_remaining desc, inst_id, sid;
