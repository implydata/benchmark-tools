CREATE TABLE ssb_testing.ssb_flat
WITH (
  format='ORC',
  external_location='s3://bhopp-testing/ssb_testing/denormalized/'
) AS
SELECT *
FROM lineorder lo
LEFT JOIN customer c
    ON lo.lo_custkey = c.c_custkey
LEFT JOIN supplier s
    ON lo.lo_suppkey = s.s_suppkey
LEFT JOIN part p
    ON lo.lo_partkey = p.p_partkey
LEFT JOIN date d
    ON lo.lo_orderdate = d.d_datekey;