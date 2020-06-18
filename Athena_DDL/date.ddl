CREATE EXTERNAL TABLE `date`(
  `d_datekey` int,
  `d_date` string,
  `d_dayofweek` string,
  `d_month` string,
  `d_year` int,
  `d_yearmonthnum` int,
  `d_yearmonth` string,
  `d_daynuminweek` int,
  `d_daynuminmonth` int,
  `d_daynuminyear` int,
  `d_monthnuminyear` int,
  `d_weeknuminyear` int,
  `d_sellingseason` string,
  `d_lastdayinweekfl` int,
  `d_lastdayinmonthfl` int,
  `d_holidayfl` int,
  `d_weekdayfl` int)
  ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\|'
    MAP KEYS TERMINATED BY 'undefined'
  STORED AS INPUTFORMAT
    'org.apache.hadoop.mapred.TextInputFormat'
  OUTPUTFORMAT
    'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
  LOCATION
    's3://ssbdata/ssb-dbgen/date/'
