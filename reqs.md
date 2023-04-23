Points:
2 points: Problem is well described and it's clear what the problem the project solves

4 points: The project is developed in the cloud and IaC tools are used

4 points: End-to-end pipeline: multiple steps in the DAG, uploading data to data lake

4 points: Tables are partitioned and clustered in a way that makes sense for the upstream queries (with explanation)

4 points: Tranformations are defined with dbt, Spark or similar technologies

4 points: A dashboard with 2 tiles

4 points: Instructions are clear, it's easy to run the code, and the code works



Stack would be:
GCP (VM, GCS, BigQuery, DataStudio)
Apache Spark for transformations
Airflow for orchestration
Terraform for IaC

Batch hourly


Notes:
I must store API key securely (in .gitignored file at least)
It's better to parametrize API params and expose them

improvements: 
. transform city name to geocode
https://openweathermap.org/api/geocoding-api