drop table if exists dezdb.stg_games_detailed;

drop table if exists dezdb.stg_games_detailed;

create table if not exists dezdb.stg_games_detailed
engine MergeTree
order by id
as select type
,ID as id
,thumbnail
,image
,primary
,alternate
,description
,yearpublished
,minplayers
,maxplayers
,suggested_num_players
,suggested_playerage
,suggested_language_dependence
,playingtime
,minplaytime
,maxplaytime
,minage
,boardgamecategory
,boardgamemechanic
,boardgamefamily
,boardgameexpansion
,boardgameimplementation
,boardgamedesigner
,boardgameartist
,boardgamepublisher
,usersrated
,average
,bayesaverage
,"Board Game Rank"
,"Strategy Game Rank"
,"Family Game Rank"
,stddev
,median
,owned
,trading
,wanting
,wishing
,numcomments
,numweights
,averageweight
,boardgameintegration
,boardgamecompilation
,"Party Game Rank"
,"Abstract Game Rank"
,"Thematic Rank"
,"War Game Rank"
,"Customizable Rank"
,"Children's Game Rank"
,"RPG Item Rank"
,"Accessory Rank"
,"Video Game Rank"
,"Amiga Rank"
,"Commodore 64 Rank"
,"Arcade Rank"
,"Atari ST Rank"
FROM s3('https://storage.yandexcloud.net/dez-rzv-final-project/data/games_detailed_info.csv', 'CSVWithNames', 'type String,ID Int32,thumbnail String,image String,primary String,alternate String,description String,yearpublished Int16,minplayers Int8,maxplayers Int8,suggested_num_players String,suggested_playerage String,suggested_language_dependence String,playingtime Int8,minplaytime Int8,maxplaytime Int8,minage Int8,boardgamecategory String,boardgamemechanic String,boardgamefamily String,boardgameexpansion String,boardgameimplementation String,boardgamedesigner String,boardgameartist String,boardgamepublisher String,usersrated Int32,average decimal(10,7),bayesaverage decimal(10,7),"Board Game Rank" String,"Strategy Game Rank" String,"Family Game Rank" String,stddev decimal(10,7),median decimal(10,7),owned Int32,trading Int32,wanting Int32,wishing Int32,numcomments Int32,numweights Int32,averageweight decimal(10,7),boardgameintegration String,boardgamecompilation String,"Party Game Rank" String,"Abstract Game Rank" String,"Thematic Rank" String,"War Game Rank" String,"Customizable Rank" String,"Children''s Game Rank" String,"RPG Item Rank" String,"Accessory Rank" String,"Video Game Rank" String,"Amiga Rank" String,"Commodore 64 Rank" String,"Arcade Rank" String,"Atari ST Rank" String');


drop table if exists dezdb.stg_games_aggregated;

create table if not exists dezdb.stg_games_aggregated
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
FROM s3('https://storage.yandexcloud.net/dez-rzv-final-project/data/2022-01-08.csv',  'CSVWithNames', 'ID UInt32,Name String,Year UInt16,Rank UInt16,Average decimal(10,5),"Bayes average" decimal(10,5),"Users rated" UInt32,URL String,Thumbnail String');

drop table if exists dezdb.stg_games_reviews;

create table if not exists dezdb.stg_games_reviews
engine MergeTree
order by id
as select user
,rating
,comment
,ID as id
,name
FROM s3('https://storage.yandexcloud.net/dez-rzv-final-project/data/bgg-19m-reviews.csv', 'CSVWithNames', 'user String,rating decimal(10,5),comment String,ID UInt32,name String');


select * from dezdb.games_aggregated
limit 10;

select * from dezdb.games_detailed
limit 10;

select * from dezdb.games_reviews
limit 10;


create or replace view dezdb.v_reviews
as 
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
from dezdb.games_reviews r;

create or replace view dezdb.v_detailed
as 
select type
,id
,thumbnail
,image
,primary
,alternate
,description
,yearpublished
,minplayers
,maxplayers
,suggested_num_players
,suggested_playerage
,suggested_language_dependence
,playingtime
,minplaytime
,maxplaytime
,minage
,boardgamecategory
,boardgamemechanic
,boardgamefamily
,boardgameexpansion
,boardgameimplementation
,boardgamedesigner
,boardgameartist
,boardgamepublisher
,usersrated
,average
,bayesaverage
,toUInt32OrNull("Board Game Rank") "Board Game Rank"
,toUInt32OrNull("Strategy Game Rank") "Strategy Game Rank"
,toUInt32OrNull("Family Game Rank") "Family Game Rank"
,stddev
,median
,owned
,trading
,wanting
,wishing
,numcomments
,numweights
,averageweight
,boardgameintegration
,boardgamecompilation
,toUInt32OrNull("Party Game Rank") "Party Game Rank"
,toUInt32OrNull("Abstract Game Rank") "Abstract Game Rank"
,toUInt32OrNull("Thematic Rank") "Thematic Rank"
,toUInt32OrNull("War Game Rank") "War Game Rank"
,toUInt32OrNull("Customizable Rank") "Customizable Rank"
,toUInt32OrNull("Children's Game Rank") "Children's Game Rank"
,toUInt32OrNull("RPG Item Rank") "RPG Item Rank"
,toUInt32OrNull("Accessory Rank") "Accessory Rank"
,toUInt32OrNull("Video Game Rank") "Video Game Rank"
,toUInt32OrNull("Amiga Rank") "Amiga Rank"
,toUInt32OrNull("Commodore 64 Rank") "Commodore 64 Rank"
,toUInt32OrNull("Arcade Rank") "Arcade Rank"
,toUInt32OrNull("Atari ST Rank") "Atari ST Rank"
from dezdb.games_detailed;

create or replace view dezdb.v_reviews_agg_by_comm_bucket
as 
select r.comment_len_bucket
,round(avg(rating),3) as avg_rating
,count(rating) as cnt
from dezdb.v_reviews r
group by r.comment_len_bucket;

create or replace view dezdb.v_ratings_agg_by_year
as select Year
, max("Bayes average") as mx_avg
, min("Bayes average") as mn_avg
, max("Users rated") as mx_usrs_rated
, min("Users rated") as mn_usrs_rated
, max(Rank) as mx_rank
, min(Rank) as mn_rank
, count(1) as cnt_published
from dezdb.games_aggregated
where Year > 0
group by Year;

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
    , max("Bayes average") as mx_avg
    , min("Bayes average") as mn_avg
    , max("Users rated") as mx_usrs_rated
    , min("Users rated") as mn_usrs_rated
    , max(Rank) as mx_rank
    , min(Rank) as mn_rank
    , count(1) as cnt_published
from dezdb.games_aggregated
group by year_bucket;