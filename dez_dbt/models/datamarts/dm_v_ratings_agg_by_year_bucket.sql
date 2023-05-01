{{ config(materialized='view') }}

select 
     case 
        when Year < 1 then 'bc'
        when Year between 1 and 1000 then '1 to 1000'
        when Year between 1001 and 1500 then '1001 to 1500'
        when Year between 1501 and 1750 then '1501 to 1750'
        when Year between 1751 and 1900 then '1751 to 1900'
        when Year between 1901 and 1950 then '1901 to 1950'
        when Year between 1951 and 1975 then '1951 to 1975'
        when Year between 1976 and 1990 then '1976 to 1990'
        when Year between 1991 and 2000 then '1991 to 2000'
        when Year between 2001 and 2010 then '2001 to 2010'
        when Year between 2011 and 2020 then '2011 to 2020'
        when Year between 2021 and toInt32(date_trunc('year', now())) then '2021 to now'
        when Year >= toInt32(date_trunc('year', now())) then 'Future'
     end year_bucket
    ,max("Bayes average") as mx_avg
    ,min("Bayes average") as mn_avg
    ,max("Users rated") as mx_usrs_rated
    ,min("Users rated") as mn_usrs_rated
    ,max(Rank) as mx_rank
    ,min(Rank) as mn_rank
    ,count(1) as cnt_published
from {{ source('dezdb','stg_games_aggregated') }}
group by year_bucket