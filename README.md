# benchmark-tools

##### Evaluating enterprise data warehouse performance using the Star Schema Benchmark 

The [Star Schema Benchmark](https://www.cs.umb.edu/~poneil/StarSchemaB.PDF) or SSB is designed to evaluate database system performance of star schema data warehouse queries. The schema for SSB is based on the TPC-H benchmark, but in a highly modified form. The SSB has been used to measure query performance of commercial and open-source database products on Linux and Windows since January 2007. Testing using the performance results of 13 standard SQL queries allows for comparison between products and configurations. 

This testing evaluates the suitability of [Apache Druid](https://druid.apache.org) and [Google BigQuery](https://cloud.google.com/bigquery) for EDW workloads in terms of performance and price-performance using SSB. EDW workloads are shifting to the cloud and, as a result, a new class of technologies is emerging that can provide fast query response times at scale. These solutions load, store and analyze large amounts of data at high speed to prove timely business insights. New columnar architectures provide microsecond response time at high levels of concurrency where traditional EDW struggle. When deployed elastically as a service, they enable enterprises to innovate BI and OLAP apps at a more rapid pace.  

This readme is an excerpt from a [larger report](https://go.imply.io/rs/910-OTN-223/images/Apache-Druid-and-Google-BigQuery-performance-evaluation.pdf) and is organized in the following sections:
1. [Testing Methodology](https://github.com/implydata/benchmark-tools#testing-methodology)
2. [Data Generation and Preparation](https://github.com/implydata/benchmark-tools#data-generation-and-preparation)
3. [Data Ingestion](https://github.com/implydata/benchmark-tools#data-ingestion)
4. [Query Optimization](https://github.com/implydata/benchmark-tools#query-optimization)
5. [Performance Testing](https://github.com/implydata/benchmark-tools#performance-testing)
6. [Results](https://github.com/implydata/benchmark-tools#results)

## Testing Methodology

We evaluated the performance of Apache Druid and Google BigQuery to determine the suitability of each as an enterprise data warehouse (EDW) solution. Testing involved five major steps for each solution:
1.	Provision each solution 
2.	Generate and prepare SSB test data
3.	Ingest SSB test data with optimal schema
4.	Optimize SSB test queries
5.	Performance test using Apache JMeter

We optimized schema and queries following documented best practices for each platform. The SSB papers are clear in their vagueness regarding optimization ground rules.
1.	Columns in SSB tables can be compressed by whatever means available in the database system used, as long as reported data retrieved by queries has the values specified in the original schema.
2.	Any product capability used in one product database design to improve performance must be matched in the database design for other products by an attempt to use the same type of capability, assuming such a capability exists and improves performance.
3.	Materialized Views that pre-join some useful dimension columns with the lineorder table are permitted. 
4.	Denormalization is not only acceptable, it is considered a standard practice in data warehousing.
5.	Queries are designed to select from the lineorder table exactly once (no self-joins or subqueries or table queries) to represent “classic” data warehouse queries of select from the fact table with restrictions on the data table attributes. 
6.	Queries are chosen as much as possible to span the tasks performed by an analyst, starting broadly and the increasing restrictions through the query group.
7.	Variant query forms are allowed. Any alternative SQL form that modifies predicate restrictions but retains the same effect on retrieval is fine. 
8.	Query cache must be disabled, although OS and hardware level caching may not. Caching rules must be documented.
9.	SSB reports must include a scale factor, database product name, version number, processor model and number of processors, memory space, disk setup, and all other parameters that may impact performance.
10.	Any tuning capability habitually used to improve performance in a database product should be adopted for that product.
11.	Published SSB reports can anonymize the products tested, removing product-specific tuning details and query plans

## Data Generation and Preparation

We generated 600 million rows (approximately 100GB) of test data using SSB’s dbgen downloaded from  https://github.com/lemire/StarSchemaBenchmark and executed locally. The test files generated included the fact table lineorder.tbl, and the dimension tables customer.tbl, part.tbl, supplier.tbl, and date.tbl. We executed dbgen with a Scale Factor of 1 (SF=1) to generate a lineorder table with 6,000,000 rows.

We denormalized the SSB data to create a single flat file using Amazon Athena (Hive). We partitioned the denormalized data by month. [Athena DDL](Athena_DDL)

## Data Ingestion
We partitioned on month in the source data and saved it in ORC for Druid and BigQuery. 

In Druid’s case, we installed the druid-ORC extension and then ingested partitioned source data in ORC format. Data was partitioned on month and ingested by parsing lo_orderdate. [Druid ingestion and tuning specs](Apache_Druid)   

In BigQuery we performed the following steps:
1.	Create a table
2.	Run a data transfer job on our ORC test data from S3 and insert 
3.	Create another table with an additional column f0_ so data can be partitioned by date
[BigQuery DDL](Google_BigQuery)

## Query Optimization
We leveraged platform-specific syntax for date expressions in [SSB queries](Star_Schema_Benchmark). This enabled us to limit queries across partitions and to filter on time using the platform’s strengths to reduce the number of columns and rows that needed to be scanned. We also applied general SQL query optimization tactics such as simplifying expressions to aid in query planning.

## Performance Testing
We used JMeter to assess single-user query performance. No multi-user testing was performed. [Apache Druid JMeter script](https://github.com/implydata/benchmark-tools/blob/master/Apache_Druid/Druid_SSB_testplan.jmx) 
We ran JMeter against each platform’s HTTP API under the following conditions:
1.  Query cache off
2.  Each SSB query was run 10 times (10 samples per query)
3.  Each query flight consisted of all 13 SSB queries run in succession
4.  For each test, Average Response Time, Lowest Response Time, Highest Response Time, and Average Response Time Standard Deviation per query were calculated 
5.  Each test was repeated five times 
6.  The lowest and highest test results were discarded, a standard practice to remove outliers  from performance testing results, leaving results from 3 test runs 
7.  The remaining 3 results for each query were averaged to provide results for Average Response Time, Lowest Response Time, Highest Response Time, and Average Response Time Standard Deviation per query were calculated

## Results
Below are results for Apache Druid of our testing using the 600 million row SSB data set. Average response time is shown in milliseconds per query and also for the entire flight of 13 queries. The table below will be updated as results become available for new releases of Druid. 

|              | **Apache Druid 0.20 API** | **Apache Druid 0.18 API** |
|--------------|-----------------------:|-----------------------:|
|**Query 1.1**    |                   126 |                  1245 |
|**Query 1.2**    |                    95 |                   155 |
|**Query 1.3**    |                    93 |                    92 |
|**Query 2.1**    |                   352 |                    662 |
| **Query 2.2**    |                   327 |                   591 |
|**Query 2.3**    |                   242 |                   319 |
| **Query 3.1**    |                   329 |                   1020 |
| **Query 3.2**    |                   265 |                    514 |
| **Query 3.3**    |                   224 |                   417 |
| **Query 3.4**    |                   171 |                   100 |
| **Query 4.1**    |                   394 |                  883 |
| **Query 4.2**    |                   519 |                  389 |
| **Query 4.3**    |                   462 |                   384 |
| **Query Flight** |                  3599 |                6770 |
