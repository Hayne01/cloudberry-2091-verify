-- PAX sparse filter drops rows for "<col> IS NULL" after a DELETE: on a pax table whose column is all NULL
-- within a block, deleting any row from that block makes WHERE <col> IS NULL skip the whole block
-- (returns 0 instead of the remaining rows). pax.enable_sparse_filter = off returns the correct count.
-- First surfaced: sqlancer QUERY_PARTITIONING (TLP WHERE) on 10.12.72.52 (ARM),
-- HashData Lightning 2.1.0-devel build 152581.
-- Run: psql -e -d <db> -f repro_pax_sparse_filter_isnull_after_delete.sql > repro_pax_sparse_filter_isnull_after_delete.log 2>&1

\set ON_ERROR_STOP off
\timing on

\echo
\echo ===== pax table, c0 all NULL, one row deleted: WHERE c0 IS NULL returns 0 instead of 2 =====
SELECT version();
CREATE TABLE t(c0 int, c1 boolean) USING pax;
INSERT INTO t(c1) VALUES (TRUE), (FALSE), (FALSE);
DELETE FROM t WHERE c1;

SELECT count(*) FROM t;
SELECT count(*) FROM t WHERE c0 IS NULL;

SET pax.enable_sparse_filter = off;
SELECT count(*) FROM t WHERE c0 IS NULL;
