-- Machine-parseable contrast for apache/cloudberry#2091.
-- c0 is all NULL; deleting one row from the only group must NOT make
-- "WHERE c0 IS NULL" skip the block. Expected: 2 with sparse filter on.
CREATE TABLE t(c0 int, c1 boolean) USING pax;
INSERT INTO t(c1) VALUES (TRUE), (FALSE), (FALSE);
DELETE FROM t WHERE c1;
SELECT 'sparse_on_isnull_count' AS label, count(*) AS val FROM t WHERE c0 IS NULL;
SET pax.enable_sparse_filter = off;
SELECT 'sparse_off_isnull_count' AS label, count(*) AS val FROM t WHERE c0 IS NULL;