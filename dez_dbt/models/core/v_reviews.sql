{{ config(materialized='view') }}

select r.user
,r.rating
,case when empty(r.comment) then null else r.comment end comment
,r.id
,r.name
,case 
    when length(r.comment) <= 0 then 'Empty'
    when length(r.comment) between 1 and 25 then '1 to 25 chars'
    when length(r.comment) between 26 and 50 then '26 to 50 chars'
    when length(r.comment) between 51 and 100 then '51 to 100 chars'
    when length(r.comment) between 100 and 250 then '100 to 250 chars'
    when length(r.comment) > 250 then 'More than 250 chars'
    end comment_len_bucket
from {{ source('dezdb','stg_games_reviews') }} r

{% if var('is_test_run', default=false) %}

  limit 100

{% endif %}