{{ config(materialized='view') }}

select 
     Year
    ,max("Bayes average") as mx_avg
    ,min("Bayes average") as mn_avg
    ,max("Users rated") as mx_usrs_rated
    ,min("Users rated") as mn_usrs_rated
    ,max(Rank) as mx_rank
    ,min(Rank) as mn_rank
    ,count(1) as cnt_published
from {{ source('dezdb','stg_games_aggregated') }}
where Year > 0
group by Year