
DROP DATABASE IF EXISTS movielens;
CREATE DATABASE movielens;

-- Movies tables

DROP TABLE IF EXISTS movielens.movies;

CREATE EXTERNAL TABLE movielens.movies (
  movieid int,
  title string,
  genres string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = '@'
) LOCATION 's3://radek-datasets/movielens/demo/movies/'
TBLPROPERTIES (
    'has_encrypted_data'='false',
    'skip.header.line.count' = '0'
);

select * from movielens.movies limit 10;

--- Ratings

DROP TABLE IF EXISTS movielens.ratings;

CREATE EXTERNAL TABLE IF NOT EXISTS movielens.ratings (
  `userid` int,
  `movieid` int,
  `rating` double,
  `time` int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = '@'
) LOCATION 's3://radek-datasets/movielens/demo/ratings/'
TBLPROPERTIES (
    'has_encrypted_data'='false',
    'skip.header.line.count' = '0'
);

select * from movielens.ratings limit 10;

-- Tags

DROP TABLE IF EXISTS movielens.tags;

CREATE EXTERNAL TABLE IF NOT EXISTS movielens.tags (
  userid int,
  movieid int,
  tag string,
  time int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = '@'
) LOCATION 's3://radek-datasets/movielens/demo/tags/'
TBLPROPERTIES (
    'has_encrypted_data'='false',
    'skip.header.line.count' = '0'
);

select * from movielens.tags limit 10;