use role sysadmin;

drop database if exists citibike;
create database citibike;

use database citibike;
use schema public;

-- creating table for data

create table trips
(tripduration integer,
  starttime timestamp,
  stoptime timestamp,
  start_station_id integer,
  start_station_name string,
  start_station_latitude float,
  start_station_longitude float,
  end_station_id integer,
  end_station_name string,
  end_station_latitude float,
  end_station_longitude float,
  bikeid integer,
  membership_type string,
  usertype string,
  birth_year integer,
  gender integer);

-- creating stage

create or replace stage citibike_trips url = 's3://snowflake-workshop-lab/citibike-trips-csv/';

show stages;

list @citibike_trips;

-- creating file format

create or replace file format csv type='csv'
  compression = 'auto' field_delimiter = ',' record_delimiter = '\n'
  skip_header = 0 field_optionally_enclosed_by = '\042' trim_space = false
  error_on_column_count_mismatch = false escape = 'none' escape_unenclosed_field = '\134'
  date_format = 'auto' timestamp_format = 'auto' null_if = ('');

show file formats in database citibike;

describe file format csv;


-- create warehouse

create or replace warehouse analytics_wh with warehouse_size = 'small' warehouse_type = 'standard'
  auto_suspend = 10 auto_resume = true;

show warehouses;

use warehouse analytics_wh;



-- loading data

copy into trips from @citibike_trips file_format=csv;
select count(*) from trips;

truncate table trips;
select count(*) from trips;
alter warehouse compute_wh set warehouse_size='large';
copy into trips from @citibike_trips file_format=csv;




select * from trips limit 20;



select date_trunc('hour', starttime) as "date",
count(*) as "num trips",
avg(tripduration)/60 as "avg duration (mins)",
avg(haversine(start_station_latitude, start_station_longitude, end_station_latitude, end_station_longitude)) as "avg distance (km)"
from trips
group by 1 order by 1
limit 1000;

ALTER SESSION SET USE_CACHED_RESULT = FALSE;
ALTER SESSION SET USE_CACHED_RESULT = TRUE;



select monthname(starttime) as "month",
    count(*) as "num trips"
from trips
group by 1 order by 2 desc;



-- cloning table
create table trips_dev clone trips;



drop database if exists weather;
create database weather;
use database weather;
use schema public;


create table json_weather_data (v variant);

create stage nyc_weather url = 's3://snowflake-workshop-lab/weather-nyc';

list @nyc_weather;


copy into json_weather_data
from @nyc_weather
file_format = (type=json);


select * from json_weather_data limit 10;


create view json_weather_data_view as
select
  v:time::timestamp as observation_time,
  v:city.id::int as city_id,
  v:city.name::string as city_name,
  v:city.country::string as country,
  v:city.coord.lat::float as city_lat,
  v:city.coord.lon::float as city_lon,
  v:clouds.all::int as clouds,
  (v:main.temp::float)-273.15 as temp_avg,
  (v:main.temp_min::float)-273.15 as temp_min,
  (v:main.temp_max::float)-273.15 as temp_max,
  v:weather[0].main::string as weather,
  v:weather[0].description::string as weather_desc,
  v:weather[0].icon::string as weather_icon,
  v:wind.deg::float as wind_dir,
  v:wind.speed::float as wind_speed
from json_weather_data
where city_id = 5128638;


select * from json_weather_data_view
where date_trunc('month',observation_time) = '2018-01-01'
limit 20;


select weather as conditions
    ,count(*) as num_trips
from citibike.public.trips
left outer join json_weather_data_view
    on date_trunc('hour', observation_time) = date_trunc('hour', starttime)
where conditions is not null
group by 1 order by 2 desc;



-- undrop table
drop table json_weather_data;
-- select * from json_weather_data limit 10;

undrop table json_weather_data;
select * from json_weather_data limit 10;


-- roll back a table
use database citibike;
use schema public;

update trips set start_station_name = 'oops';

select start_station_name as station
    ,count(*) as rides
from trips
group by 1
order by 2 desc
limit 20;

set query_id =
(select query_id from
table(information_schema.query_history_by_session (result_limit=>5))
where query_text like 'update%' order by start_time limit 1);

create or replace table trips as
(select * from trips before (statement => $query_id));

select start_station_name as "station"
    ,count(*) as "rides"
from trips
group by 1
order by 2 desc
limit 20;



use role accountadmin;
drop role if exists junior_dba;
create role junior_dba;

select current_user(); --your name in next query
grant role junior_dba to user radoslawszmit;

-- use role junior_dba;
-- select * from trips limit 10;

use role accountadmin;

grant usage on database citibike to role junior_dba;
grant usage on database weather to role junior_dba;

grant usage on all schemas in database citibike to role junior_dba;
grant usage on all schemas in database weather to role junior_dba;

grant select on all tables in database citibike to role junior_dba;
grant select on all tables in database weather to role junior_dba;

grant usage on warehouse analytics_wh to role junior_dba;


use role junior_dba;
use database citibike;
use schema public;
use warehouse analytics_wh;
select * from trips limit 10;

