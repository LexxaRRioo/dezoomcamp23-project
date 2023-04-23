drop table dezdb.games_detailed_info;

create table dezdb.games_detailed_info (
     rowid UInt32
    ,type String
    ,id UInt64
    ,thumbnail String
    ,image String
    ,primary String
    ,alternate String
    ,description String
    ,yearpublished UInt16
    ,minplayers UInt8
    ,maxplayers UInt8
    ,suggested_num_players String
    ,suggested_playerage String
    ,suggested_language_dependence String
    ,playingtime UInt8
    ,minplaytime UInt8
    ,maxplaytime UInt8
    ,minage UInt8
    ,boardgamecategory String
    ,boardgamemechanic String
    ,boardgamefamily String
    ,boardgameexpansion String
    ,boardgameimplementation String
    ,boardgamedesigner String
    ,boardgameartist String
    ,boardgamepublisher String
    ,usersrated UInt32
    ,average Float32
    ,bayesaverage Float32
    ,Board_Game_Rank UInt32
    ,Strategy_Game_Rank UInt32
    ,Family_Game_Rank UInt32
    ,stddev Float32
    ,median Float32
    ,owned UInt32
    ,trading UInt32
    ,wanting UInt32
    ,wishing UInt32
    ,numcomments UInt32
    ,numweights UInt32
    ,averageweight Float32
    ,boardgameintegration String
    ,boardgamecompilation String
    ,Party_Game_Rank UInt32
    ,Abstract_Game_Rank UInt32
    ,Thematic_Rank UInt32
    ,War_Game_Rank UInt32
    ,Customizable_Rank UInt32
    ,Childrens_Game_Rank UInt32
    ,RPG_Item_Rank UInt32
    ,Accessory_Rank UInt32
    ,Video_Game_Rank UInt32
    ,Amiga_Rank UInt32
    ,Commodore_64_Rank UInt32
    ,Arcade_Rank UInt32
    ,Atari_ST_Rank UInt32
) ENGINE = MergeTree 
--partition by yearpublished
order by id;

INSERT INTO dezdb.games_detailed_info
SELECT rowid
,type
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
,"Board Game Rank" as Board_Game_Rank
,"Strategy Game Rank" as Strategy_Game_Rank
,"Family Game Rank" as Family_Game_Rank
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
,"Party Game Rank" as Party_Game_Rank
,"Abstract Game Rank" as Abstract_Game_Rank
,"Thematic Rank" as Thematic_Rank
,"War Game Rank" as War_Game_Rank
,"Customizable Rank" as Customizable_Rank
,"Children's Game Rank" as Childrens_Game_Rank
,"RPG Item Rank" as RPG_Item_Rank
,"Accessory Rank" as Accessory_Rank
,"Video Game Rank" as Video_Game_Rank
,"Amiga Rank" as Amiga_Rank
,"Commodore 64 Rank" as Commodore_64_Rank
,"Arcade Rank" as Arcade_Rank
,"Atari ST Rank" as Atari_ST_Rank
FROM s3('https://storage.yandexcloud.net/dez-rzv-final-project/data/games_detailed_info.csv','','',  'CSVWithNames');


create table dezdb.games_aggregated_data
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
FROM s3('https://storage.yandexcloud.net/dez-rzv-final-project/data/2022-01-08.csv','','',  'CSVWithNames', 'ID UInt32,Name String,Year UInt16,Rank UInt16,Average decimal(18,6),"Bayes average" decimal(18,6),"Users rated" UInt32,URL String,Thumbnail String');