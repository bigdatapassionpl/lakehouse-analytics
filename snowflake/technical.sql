
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