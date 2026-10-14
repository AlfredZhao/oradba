@@lib/bootstrap.sql &1 &2
whenever sqlerror exit sql.sqlcode rollback
@&3
exit success
