Points:
2 points: Problem is well described and it's clear what the problem the project solves

4 points: The project is developed in the cloud and IaC tools are used

4 points: End-to-end pipeline: multiple steps in the DAG, uploading data to data lake

4 points: Tables are partitioned and clustered in a way that makes sense for the upstream queries (with explanation)

4 points: Tranformations are defined with dbt, Spark or similar technologies

4 points: A dashboard with 2 tiles

4 points: Instructions are clear, it's easy to run the code, and the code works


Stack would be:
Yandex Cloud as cloud provider (VM, Clickhouse, Object storage(S3-like))
DBT for transformations
Nothing for orchestration because it's single run of ETL
Terraform for IaC