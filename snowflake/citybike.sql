
USE DATABASE "SNOWFLAKE_WAREHOUSE";
use schema "CITIBIKE";

select count(*) from stations;

describe table stations;

select *
from "SNOWFLAKE_WAREHOUSE"."CITIBIKE"."TRIPS"
where starttime between '2018-06-01' and '2018-07-01'
limit 10;


with trips as(
            select
                *
        from
            "SNOWFLAKE_WAREHOUSE"."CITIBIKE"."TRIPS"
        where starttime between '2018-06-01' and '2018-07-01'
             ),
     weather as(
            select
                date_trunc('day',observation_time) as observation_date
                ,temp_avg
                ,temp_min
                ,temp_max
                ,weather
                ,wind_speed
            from "CITIBIKE"."PUBLIC"."JSON_WEATHER_DATA_VIEW"
            where observation_time between '2018-06-01' and '2018-07-01'
                )
select
    trips.tripduration
    ,trips.starttime
    ,trips.stoptime
    ,trips.start_station_id
    ,trips.start_station_name
    ,trips.start_station_latitude
    ,trips.start_station_longtitude
    ,trips.end_station_latitude
    ,trips.end_station_longtitude
    ,trips.end_station_id
    ,trips.end_station_name
    ,trips.bike_id
    ,trips.usertype
    ,trips.birth_year
    ,trips.gender
    ,observation_date
    ,temp_avg
    ,temp_min
    ,temp_max
    ,weather
    ,wind_speed
from trips
left join weather on trips.starttime=weather.observation_date;


with trips as(
            select
                tripduration
                ,starttime
                ,stoptime
                ,start_station_id
                --,START_STATION_NAME
                --,start_station_latitude
                ,start_station_longtitude
                ,end_station_latitude
                ,end_station_longtitude
                ,end_station_id
                ,end_station_name
                ,bike_id
                ,usertype
                ,birth_year
            ,gender
        from
            "SNOWFLAKE_WAREHOUSE"."CITIBIKE"."TRIPS"
        where starttime between '2018-06-01' and '2018-07-01'
             ),
     weather as(
            select
                date_trunc('day',observation_time) as observation_date
                ,temp_avg
                ,temp_min
                ,temp_max
                ,weather
                ,wind_speed
            from "JSON_WEATHER_DATA_VIEW"
            where observation_time between '2018-06-01' and '2018-07-01'
                )
select
    trips.tripduration
    ,trips.starttime
    ,trips.stoptime
    ,trips.start_station_id
    ,trips.start_station_name
    ,trips.start_station_latitude
    ,trips.start_station_longtitude
    ,trips.end_station_latitude
    ,trips.end_station_longtitude
    ,trips.end_station_id
    ,trips.end_station_name
    ,trips.bike_id
    ,trips.usertype
    ,trips.birth_year
    ,trips.gender
    ,observation_date
    ,temp_avg
    ,temp_min
    ,temp_max
    ,weather
    ,wind_speed
from trips
left join weather on trips.starttime=weather.observation_date;