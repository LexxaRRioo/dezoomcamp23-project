{% macro init_s3_sources() -%}

    {% set sources = [
        'drop table if exists dezdb.stg_games_aggregated'

        , 'create table if not exists dezdb.stg_games_aggregated
        engine MergeTree
        order by id
        as select ID as id
        ,Name
        ,Year
        ,Rank
        ,Average
        ,"Bayes average"
        ,"Users rated"
        ,URL
        ,Thumbnail
        FROM s3(\'https://storage.yandexcloud.net/dez-rzv-final-project/data/2022-01-08.csv\'
            , \'{{ var(aws_key_id) }}\'
            , \'{{ var(aws_access_key) }}\'
            , \'CSVWithNames\'
            , \'ID UInt32,Name String,Year UInt16,Rank UInt16,Average decimal(10,5),"Bayes average" decimal(10,5),"Users rated" UInt32,URL String,Thumbnail String\'
            )
        '

        , 'drop table if exists dezdb.stg_games_reviews'

        , 'create table if not exists dezdb.stg_games_reviews
        engine MergeTree
        order by id
        as select user
        ,rating
        ,comment
        ,ID as id
        ,name
        FROM s3(\'https://storage.yandexcloud.net/dez-rzv-final-project/data/bgg-19m-reviews.csv\'
            , \'{{ var(aws_key_id) }}\'
            , \'{{ var(aws_access_key) }}\'
            , \'CSVWithNames\'
            , \'user String,rating decimal(10,5),comment String,ID UInt32,name String\'
            )
        '
    ] %}

    {% for src in sources %}
        {% set statement = run_query(src) %}
    {% endfor %}

{{ print('Initialized source tables (S3)') }}    

{%- endmacro %}