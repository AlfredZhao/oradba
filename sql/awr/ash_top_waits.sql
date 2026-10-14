-- &1 is validated by bin/oradba as a positive hour count.
column wait_class format a20
column event format a46
column sql_id format a13
select *
from (
  select wait_class, event, sql_id, count(*) as ash_samples,
         round(count(*) * 10 / 60, 1) as estimated_active_minutes
  from dba_hist_active_sess_history
  where sample_time >= systimestamp - numtodsinterval(&1, 'HOUR')
    and session_type = 'FOREGROUND'
  group by wait_class, event, sql_id
  order by ash_samples desc
)
fetch first 30 rows only;
