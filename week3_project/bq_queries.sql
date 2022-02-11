SELECT count(*), EXTRACT(YEAR FROM pickup_datetime) AS year_col  
FROM `de-bootcamp-339509.trips_data_all.fhv_tripdata` 
GROUP BY year_col
ORDER BY year_col LIMIT 10; 
42084899


SELECT count(DISTINCT dispatching_base_num) , EXTRACT(YEAR FROM pickup_datetime) AS year_col  
FROM `de-bootcamp-339509.trips_data_all.fhv_tripdata` 
GROUP BY year_col; 
792

SELECT count(*)
FROM `de-bootcamp-339509.trips_data_all.fhv_tripdata` 
WHERE dispatching_base_num IN ('B00987', 'B02060', 'B02279')
AND  DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-03-31';


CREATE OR REPLACE TABLE `de-bootcamp-339509.trips_data_all.fhv_partitioned_tripdata`
 PARTITION BY DATE(dropoff_datetime)
 CLUSTER BY dispatching_base_num AS (
   SELECT * FROM `de-bootcamp-339509.trips_data_all.fhv_tripdata` 
 );

SELECT count(*)
FROM `de-bootcamp-339509.trips_data_all.fhv_partitioned_tripdata`
WHERE dispatching_base_num IN ('B00987', 'B02060', 'B02279')
AND  DATE(dropoff_datetime) BETWEEN '2019-01-01' AND '2019-03-31';

This query will process 400.1 MiB when run.
26647
Query complete (0.4 sec elapsed, 170 MB processed) 