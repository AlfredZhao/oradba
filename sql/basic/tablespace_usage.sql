column tablespace_name format a30
column used_percent format 990.00
column used_gb format 999999990.00
column size_gb format 999999990.00
prompt === Permanent tablespace usage ===
select m.tablespace_name,
       round(m.used_space * t.block_size / power(1024, 3), 2) as used_gb,
       round(m.tablespace_size * t.block_size / power(1024, 3), 2) as size_gb,
       round(m.used_percent, 2) as used_percent
from dba_tablespace_usage_metrics m
join dba_tablespaces t on t.tablespace_name = m.tablespace_name
order by m.used_percent desc, m.tablespace_name;

prompt === Temp tablespace usage ===
select tablespace_name,
       round(sum(bytes_used + bytes_free) / power(1024, 3), 2) as size_gb,
       round(sum(bytes_used) / power(1024, 3), 2) as used_gb,
       round(sum(bytes_used) / nullif(sum(bytes_used + bytes_free), 0) * 100, 2) as used_percent
from v$temp_space_header
group by tablespace_name
order by used_percent desc, tablespace_name;
