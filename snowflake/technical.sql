
SELECT CURRENT_ACCOUNT();


select *
--select QUERY_ID, QUERY_TEXT,START_TIME,TOTAL_ELAPSED_TIME,BYTES_SCANNED,ROWS_PRODUCED,execution_status
from table(information_schema.query_history())
where query_text not like '%query_history%'
-- and execution_status like 'RUNNING'
order by start_time desc
limit 10;


select system$cancel_query('019238d1-03ac-3360-0000-0006fa83a2c1');

select
    max(start_time)
from
    "SNOWFLAKE"."ACCOUNT_USAGE"."METERING_HISTORY";


select current_timestamp();


SELECT CURRENT_ACCOUNT();

use role accountadmin;

grant imported privileges on database snowflake to role sysadmin;

select * from snowflake.account_usage.databases;

use role accountadmin;

use schema snowflake.account_usage;

select user_name,
       count(*) as failed_logins,
       avg(seconds_between_login_attempts) as average_seconds_between_login_attempts
from (
      select user_name,
             timediff(seconds, event_timestamp, lead(event_timestamp)
                 over(partition by user_name order by event_timestamp)) as seconds_between_login_attempts
      from login_history
      where event_timestamp > date_trunc(month, current_date)
      and is_success = 'NO'
     )
group by 1
order by 3;


select user_name,
       sum(iff(is_success = 'NO', 1, 0)) as failed_logins,
       count(*) as logins,
       sum(iff(is_success = 'NO', 1, 0)) / nullif(count(*), 0) as login_failure_rate
from login_history
where event_timestamp > date_trunc(month, current_date)
group by 1
order by 4 desc;


select reported_client_type,
       user_name,
       sum(iff(is_success = 'NO', 1, 0)) as failed_logins,
       count(*) as logins,
       sum(iff(is_success = 'NO', 1, 0)) / nullif(count(*), 0) as login_failure_rate
from login_history
where event_timestamp > date_trunc(month, current_date)
group by 1,2
order by 5 desc;


select warehouse_name,
       sum(credits_used) as total_credits_used
from warehouse_metering_history
where start_time >= date_trunc(month, current_date)
group by 1
order by 2 desc;

select start_time::date as usage_date,
       warehouse_name,
       sum(credits_used) as total_credits_used
from warehouse_metering_history
where start_time >= date_trunc(month, current_date)
group by 1,2
order by 2,1;

select date_trunc(month, usage_date) as usage_month
  , avg(storage_bytes + stage_bytes + failsafe_bytes) / power(1024, 4) as billable_tb
from storage_usage
group by 1
order by 1;