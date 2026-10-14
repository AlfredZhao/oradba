-- &1 is validated by bin/oradba as a 13-character SQL ID; &2 is a positive day count.
var sql_id varchar2(13)
exec :sql_id := '&1';
column sql_text format a100 word_wrapped
column module format a28
prompt === Current cursor statistics ===
select inst_id, sql_id, plan_hash_value, parsing_schema_name, module,
       executions, round(elapsed_time / 1e6, 2) as elapsed_s,
       round(cpu_time / 1e6, 2) as cpu_s,
       buffer_gets, disk_reads, rows_processed,
       last_active_time
from gv$sql
where sql_id = :sql_id
order by last_active_time desc;

prompt === SQL text ===
select sql_fulltext as sql_text
from gv$sql
where sql_id = :sql_id
fetch first 1 row only;

prompt === AWR history for the requested window ===
select s.instance_number, s.snap_id,
       to_char(sn.begin_interval_time, 'yyyy-mm-dd hh24:mi') as begin_time,
       s.plan_hash_value, s.executions_delta,
       round(s.elapsed_time_delta / 1e6, 2) as elapsed_s,
       round(s.cpu_time_delta / 1e6, 2) as cpu_s,
       s.buffer_gets_delta, s.disk_reads_delta, s.rows_processed_delta
from dba_hist_sqlstat s
join dba_hist_snapshot sn
  on sn.dbid = s.dbid and sn.instance_number = s.instance_number and sn.snap_id = s.snap_id
where s.sql_id = :sql_id
  and sn.begin_interval_time >= systimestamp - numtodsinterval(&2, 'DAY')
order by sn.begin_interval_time desc, s.instance_number;

prompt === Latest cursor plan with runtime statistics ===
select plan_table_output
from table(dbms_xplan.display_cursor(:sql_id, null, 'ALLSTATS LAST +PEEKED_BINDS'));
