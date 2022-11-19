use role accountadmin;

drop database if exists dbt_db;
create database dbt_db;

drop warehouse if exists dbt_wh;
create or replace warehouse dbt_wh
    warehouse_size='xsmall'
    warehouse_type='standard'
    auto_suspend=60
    initially_suspended=true;

drop role if exists dbt_role;
create role dbt_role;

drop user if exists dtb_user;
create or replace user dbt_user
    password='*****************'
    default_role = dbt_role
    must_change_password = false;

grant role dbt_role to role sysadmin;
grant role dbt_role to user dbt_user;

grant ownership on database dbt_db to role dbt_role;
grant ownership on schema public to role dbt_role;

grant usage on warehouse dbt_wh to role dbt_role;
