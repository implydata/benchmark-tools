CREATE EXTERNAL TABLE `supplier`(
  `s_suppkey` int, 
  `s_name` string, 
  `s_address` string, 
  `s_city` string, 
  `s_nation` string, 
  `s_region` string, 
  `s_phone` string)
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
  's3://bhopp-testing/ssb_testing/normalized/supplier'