
create database if not exists movielens;

use database movielens;
use schema public;

show tables;

--- Movies

drop table if exists movies;

CREATE TABLE movies (
    movieid int,
    title varchar,
    genres varchar
);

copy into movielens.public.movies (
    movieid, title, genres
)
from 's3://radek-datasets-public/movielens/demo/movies/movies.dat'
file_format = (
  type = 'CSV'
  field_delimiter = '@'
  skip_header = 0
);

select * from movies limit 10;
select count(*) from movies;

--- RATINGS

drop table if exists ratings;

CREATE TABLE ratings (
    userid int,
    movieid int,
    rating double,
    timestamp timestamp
);

copy into movielens.public.ratings (
    userid, movieid, rating, timestamp
)
from 's3://radek-datasets-public/movielens/demo/ratings/ratings.dat'
file_format = (
  type = 'CSV'
  field_delimiter = '@'
  skip_header = 0
);

select * from ratings limit 10;
select count(*) from ratings;

--- TAGS

drop table if exists tags;

CREATE TABLE tags (
    userid int,
    movieid int,
    tag varchar,
    timestamp timestamp
);

copy into movielens.public.tags (
    userid, movieid, tag, timestamp
)
from 's3://radek-datasets-public/movielens/demo/tags/tags.dat'
file_format = (
  type = 'CSV'
  field_delimiter = '@'
  skip_header = 0
)
ON_ERROR = CONTINUE;

select * from tags limit 10;
select count(*) from tags;
