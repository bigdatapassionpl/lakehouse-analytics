use schema snowflake_warehouse.public;

select hostname, count(1) as numberofimpressions
from impressions
group by hostname
order by numberofimpressions desc
limit 10;

select referrer, count(1) as numberofimpressions
from impressions
group by referrer
order by numberofimpressions desc
limit 10;

select usercookie, count(1) as numberofimpressions
from impressions
group by usercookie
order by numberofimpressions desc
limit 10;


select count(1) as numberofuniqueusers
from (
    select distinct usercookie
    from impressions
);


select adid, usercookie, count(1) as numberofimpressions
from impressions
where adid in (
    select distinct adid
    from clicks
)
group by adid, usercookie
order by numberofimpressions desc
limit 10;


select numberofimpressions, count(1) as users
from (
    select adid, usercookie, count(1) as numberofimpressions
    from impressions
    where adid in (
        select distinct adid
        from clicks
    )
    group by adid, usercookie
) group by numberofimpressions
order by numberofimpressions desc;
