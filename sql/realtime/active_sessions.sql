column username format a18
column machine format a28
column module format a28
column event format a38
column sql_id format a13
select inst_id, sid, serial#, username, status, machine, module, sql_id,
       wait_class, event, last_call_et
from gv$session
where type = 'USER'
  and username is not null
  and status = 'ACTIVE'
order by last_call_et desc, inst_id, sid;
