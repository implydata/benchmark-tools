CREATE EXTERNAL TABLE `customer`(
  `c_custkey` int, 
  `c_name` string, 
  `c_address` string, 
  `c_city` string, 
  `c_nation` string, 
  `c_region` string, 
  `c_phone` string, 
  `c_mktsegment` string)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY '|' 
  MAP KEYS TERMINATED BY 'undefined' 
WITH SERDEPROPERTIES ( 
  'collection.delim'='undefined') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://bhopp-testing/ssb_testing/normalized/customer'