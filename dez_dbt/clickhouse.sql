drop table dezdb.games_detailed_info;

drop table if exists dezdb.games_detailed;

create table if not exists dezdb.games_detailed
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
FROM s3('https://storage.yandexcloud.net/dez-rzv-final-project/data/games_detailed_info.csv', 'CSVWithNames', 'type String,ID Int32,thumbnail String,image String,primary String,alternate String,description String,yearpublished Int16,minplayers Int8,maxplayers Int8,suggested_num_players String,suggested_playerage String,suggested_language_dependence String,playingtime Int8,minplaytime Int8,maxplaytime Int8,minage Int8,boardgamecategory String,boardgamemechanic String,boardgamefamily String,boardgameexpansion String,boardgameimplementation String,boardgamedesigner String,boardgameartist String,boardgamepublisher String,usersrated Int32,average decimal(10,7),bayesaverage decimal(10,7),"Board Game Rank" String,"Strategy Game Rank" String,"Family Game Rank" String,stddev decimal(10,7),median decimal(10,7),owned Int32,trading Int32,wanting Int32,wishing Int32,numcomments Int32,numweights Int32,averageweight decimal(10,7),boardgameintegration String,boardgamecompilation String,"Party Game Rank" String,"Abstract Game Rank" String,"Thematic Rank" String,"War Game Rank" String,"Customizable Rank" String,"Children''s Game Rank" String,"RPG Item Rank" String,"Accessory Rank" String,"Video Game Rank" String,"Amiga Rank" String,"Commodore 64 Rank" String,"Arcade Rank" String,"Atari ST Rank" String');
