
USE DATABASE "SNOWFLAKE_WAREHOUSE";
use schema "CITIBIKE";

select count(*) from stations;

describe table stations;

select *
from "SNOWFLAKE_WAREHOUSE"."CITIBIKE"."TRIPS"
where starttime between '2018-06-01' and '2018-07-01'
limit 10;