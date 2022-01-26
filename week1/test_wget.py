import os
url = 'https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv'
csv_name = 'output.csv'

os.system(f"wget {url} -O {csv_name}")
