use role accountadmin;

drop warehouse if exists dbt_wh;
drop role if exists dbt_role;
drop user if exists dtb_user;

drop database if exists dbt_db;
drop database if exists dbt_raw;
drop database if exists dbt_analytics;
