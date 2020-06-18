CREATE EXTERNAL TABLE IF NOT EXISTS ssb_testing.lineorder (
  `lo_orderkey` int,
  `lo_linenumber` int,
  `lo_custkey` int,
  `lo_partkey` int,
  `lo_suppkey` int,
  `lo_orderdate` int,
  `lo_orderpriority` string,
  `lo_shippriority` string,
  `lo_quantity` int,
  `lo_extendedprice` double,
  `lo_ordtotalprice` decimal,
  `lo_discount` decimal,
  `lo_revenue` decimal,
  `lo_supplycost` decimal,
  `lo_tax` int,
  `lo_commitdate` string,
  `lo_shipmode` string 
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '|',
  'field.delim' = '|',
  'collection.delim' = 'undefined',
  'mapkey.delim' = 'undefined'
) LOCATION 's3://bhopp-testing/ssb_testing/normalized/lineorder/'
TBLPROPERTIES ('has_encrypted_data'='false');