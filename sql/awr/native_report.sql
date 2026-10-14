-- SQLcl writes AWR-<DB>-<PDB>-<timestamp>.html in the launcher's working directory.
-- The launcher validates both snapshot IDs before this script is invoked.
awr create html &1 &2
