-- Assume the ACCOUNTADMIN role
use role accountadmin;

show users;

grant role orgadmin to user radek;

-- using orgadmin role
use role orgadmin;

select current_account();

SELECT current_account() as YOUR_ACCOUNT_LOCATOR, current_region() as YOUR_SNOWFLAKE_REGION_ID;

SHOW ORGANIZATION ACCOUNTS;
