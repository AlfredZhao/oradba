column blocker format a18
column waiter format a18
column event format a42
select w.inst_id,
       b.username || ' (' || b.sid || ',' || b.serial# || ')' as blocker,
       w.username || ' (' || w.sid || ',' || w.serial# || ')' as waiter,
       w.event, w.seconds_in_wait, w.sql_id
from gv$session w
join gv$session b
  on b.inst_id = w.blocking_instance
 and b.sid = w.blocking_session
where w.blocking_session_status = 'VALID'
order by w.seconds_in_wait desc, w.inst_id, w.sid;
