prompt === Session and database ===
select sys_context('USERENV', 'SESSION_USER') as current_user,
       sys_context('USERENV', 'DB_NAME') as db_name,
       sys_context('USERENV', 'CON_NAME') as con_name,
       sys_context('USERENV', 'CDB_NAME') as cdb_name,
       sys_context('USERENV', 'SERVER_HOST') as server_host
from dual;

select version, version_full, instance_name, host_name, status, startup_time
from v$instance;

select name, db_unique_name, cdb, open_mode, database_role, log_mode, force_logging
from v$database;

prompt === PDBs visible from this connection ===
select con_id, name, open_mode, restricted, open_time
from v$pdbs
order by con_id;

