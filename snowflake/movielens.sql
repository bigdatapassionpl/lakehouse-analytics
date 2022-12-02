
Drop database Workshops;
CREATE DATABASE Workshops;

DROP WAREHOUSE Workshops;
CREATE WAREHOUSE Workshops WITH
    WAREHOUSE_SIZE = 'MEDIUM'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE;

DROP TABLE MOVIES;
CREATE TABLE "WORKSHOPS"."PUBLIC"."MOVIES" (
  "MOVIEID" INTEGER NOT NULL,
  "TITLE" STRING NOT NULL,
  "GENRES" STRING NOT NULL)
COMMENT = 'Movies Dataset';

PUT file://<file_path>/movies.csv @MOVIES/ui1611484958060
COPY INTO "WORKSHOPS"."PUBLIC"."MOVIES" FROM @/ui1611484958060 FILE_FORMAT = '"WORKSHOPS"."PUBLIC"."MOVIELENS"' ON_ERROR = 'ABORT_STATEMENT' PURGE = TRUE;


select * from movies limit 10;

select count(*) from movies;


select count(*) as counter, year(timestamp) as year
from tags
group by year
order by counter desc
limit 10;


select count(*) as counter, t.movieid, m.title
from tags t
left join movies m on m.movieid = t.movieid
group by t.movieid, m.title
order by counter desc
limit 10;


select * from tags
where movieid in (
    select movieid
    from tags
    group by movieid
    order by count(*) desc
    limit 1
);


select count(*) as counter, userid
from tags
group by userid
order by counter desc
limit 10;


select count(*) as counter, tag
from tags
group by tag
order by counter desc
limit 10;
