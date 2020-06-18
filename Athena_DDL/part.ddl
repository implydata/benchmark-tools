CREATE EXTERNAL TABLE `part`(
  `p_partkey` int, 
  `p_name` string, 
  `p_mfgr` string, 
  `p_category` string, 
  `p_brand1` string, 
  `p_color` string, 
  `p_type` string, 
  `p_size` decimal(10,0), 
  `p_container` string)
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
  's3://bhopp-testing/ssb_testing/normalized/part'