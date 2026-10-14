-- &1 saved SQLcl Connection Manager name; &2 output directory (created by bin/oradba).
whenever oserror exit failure rollback
whenever sqlerror continue none
set echo off feedback on verify off define on
set linesize 220 pagesize 200 trimout on trimspool on tab off
set serveroutput on size unlimited
connect -name "&1"
prompt Connected with saved SQLcl connection: &1
prompt Output directory: &2
