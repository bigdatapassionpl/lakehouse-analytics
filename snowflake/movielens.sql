use database movielens;
use schema public;

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
