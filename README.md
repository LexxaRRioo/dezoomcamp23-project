# Welcome to my version of Data engineering zoomcamp 2023 final project!

This project is aimed to practice data engineering skills as final part of Data engineering zoomcamp 2023. Pipeline is built using cloud services and publicly available dataset. Dashboard answers some questions I'm interested in boardgames sphere. 

## Attention! Info for reviewers

Repo hash is different from c9c97e0 because I didn't check earlier that Dashboard link could be not accessable from some countries. Try to use any Russian vpn (for ex. Opera GX built-in VPN function works https://www.opera.com/ru/download#opera-gx) or feel free to contact me via telegram @razvodov_alexey and I'll share my screen in realtime to show it. 

(you can check diff, I'm not changing anything instead of that block of text)

### Links:
* Final dashboard: https://datalens.yandex/aq4trx4em99k0
* The zoomcamp course: https://github.com/DataTalksClub/data-engineering-zoomcamp
* My homeworks during this course: https://github.com/LexxaRRioo/de-zoomcamp2023
* Dataset used with boardgamegeek data: https://www.kaggle.com/datasets/jvanelteren/boardgamegeek-reviews (1GB compressed)
* To evaluate this project use those criterias: https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/week_7_project/README.md

## Stack - Yandex Cloud as cloud provider:
* Kaggle API as source
* Python as middleware to download an archive and upload needed files into S3
* Yandex Object Storage (S3-like) as intermediate cloud storage
* Yandex Compute Instance as VM for dbt-Core
* dbt-Core for transformations, autodocs, testing and lineage
* Yandex Managed Clickhouse as OLAP DB
* Terraform as IaC tool to spin up Clickhouse cluster and VM
* Yandex Datalens as BI tool for dashboarding
* Nothing for orchestration because it's single run of ELT 

![DEZ_project drawio](https://user-images.githubusercontent.com/63540060/235530006-03517b74-4663-4215-b7c6-f0fbfe98138b.png)

## Lineage
![lineage](https://user-images.githubusercontent.com/63540060/235883647-97bf7eff-65a3-4b36-b5eb-f7453ffc982e.png)

## Dashboard screenshot
![изображение](https://user-images.githubusercontent.com/63540060/235883905-cbfe663a-6211-4b7c-9316-9a8b4f44d262.png)

## Insights
* Average rating in reviews almost doesn't depend on comment length and slightly decreases from empty comments to long comments
* More than 80% of reviews on bgg are just numbers without comments
* Game Crokinole was released in 1876 and still in BGG top 100 games of all time
* Maximum avg rating of games published in every year increases in time - modern Boargames get higher appreciation (which could be biased with dates of reviewing and boargames creators could make modern games which are more likable for modern players)
* During Coronavirus pandemic amount of published games and max avg rating were being decreased
* Top 10 games were published in 2010s

## What I've tried and where I didn't succeed
* Secure access from managed Clickhouse to S3 object storage via service account - got 403 error and decided to use public storage
* Import wide table with detailed information about games with many categories via dbt macros - got error I guess on max_query_size but tuning of this parameter changed nothing (part of 2500 chars query was cut off)
* Provision VM setup using Terraform - got authentication error for a long time and gave up

## What I didn't try but it would be cool
* Dockerize solution and/or provision VM config using Ansible or other IaC tools
* Replace Kaggle dataset with live BoardGameGeek (BGG) API and automate batch processing via Mage or Airflow
* Move credentials to any special secure service
* Get bigger data where Spark or DuckDB to leverage their computatuon power

## How to reproduce what I did
Follow this technical instruction. I hope it would be under 30 min:
https://github.com/LexxaRRioo/dezoomcamp23-project/blob/main/setup.md
