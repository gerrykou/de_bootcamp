Q1   
spark.version   
'3.0.3'   
   
LOCAL_PREFIX="data/raw/fhvhv/2021/02"   
mkdir -p ${LOCAL_PREFIX}   
   
wget https://nyc-tlc.s3.amazonaws.com/trip+data/fhvhv_tripdata_2021-02.csv -O ${LOCAL_PREFIX}/fhvhv_tripdata_2021-02.csv

Q2   
du -sh data/parquet/fhvhv/2021/02   
210M    data/parquet/fhvhv/2021/02   

Q3   
df.groupBy(dayofmonth('pickup_datetime').alias('day')).count().orderBy('day', ascending = False).show()   
15|367170|   

Q4   
from pyspark.sql.functions import to_timestamp, col
df2 = df .withColumn('DiffInSeconds', col( 'dropoff_datetime').cast("long")- col('pickup_datetime').cast("long"))   
df2.orderBy('DiffInSeconds', ascending = False).show()
   
+-----------------+--------------------+-------------------+-------------------+------------+------------+-------+-------------+
|hvfhs_license_num|dispatching_base_num|    pickup_datetime|   dropoff_datetime|PULocationID|DOLocationID|SR_Flag|DiffInSeconds|
+-----------------+--------------------+-------------------+-------------------+------------+------------+-------+-------------+   
|           HV0005|              B02510|2021-02-11 13:40:44|2021-02-12 10:39:44|         247|          41|   null|        75540|
   
Q5   
df2.groupBy('dispatching_base_num').count().orderBy('count', ascending = False).show()   
+--------------------+-------+
|dispatching_base_num|  count|
+--------------------+-------+   
|              B02510|3233664|   
3 stages 230 tasks   

Q6   
BroadcastNestedLoopJoin   
1 stage   
+-------------------+---------------------------------------------+------+   
|puZone             |doZone                                       |cnt   |   
+-------------------+---------------------------------------------+------+   
|East New York      |Governor's Island/Ellis Island/Liberty Island|135123|   

df.groupBy('PULocationID', 'DOLocationID').count().orderBy('count', ascending = False).show()     
df.registerTempTable('notjoin')   

spark.sql("""
SELECT 
concat(PULocationID, '/',DOLocationID) AS conc,
count(*) AS cnt
FROM notjoin
GROUP BY  conc
ORDER BY cnt DESC
""").show()  

+-------+-----+
|   conc|  cnt|
+-------+-----+
|  76/76|45041|
   
spark.sql("""
SELECT 
*
FROM zones
WHERE LocationID=76
""").show()  
   
+----------+--------+-------------+------------+   
|LocationID| Borough|         Zone|service_zone|   
+----------+--------+-------------+------------+   
|        76|Brooklyn|East New York|   Boro Zone|



