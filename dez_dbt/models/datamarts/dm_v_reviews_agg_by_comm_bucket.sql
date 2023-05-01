{{ config(materialized='view') }}

select 
     comment_len_bucket
    ,round(avg(rating),3) as avg_rating
    ,count(rating) as cnt
from {{ ref('v_reviews') }}
group by comment_len_bucket