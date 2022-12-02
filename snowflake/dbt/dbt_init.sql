use role accountadmin;

create or replace warehouse dbt_wh
    warehouse_size='xsmall'
    warehouse_type='standard'
    auto_suspend=10
    initially_suspended=true;

create role dbt_role;

create or replace user dbt_user
    password='*****************'
    default_role = dbt_role
    must_change_password = false;

grant role dbt_role to role sysadmin;
grant role dbt_role to user dbt_user;

grant usage on warehouse dbt_wh to role dbt_role;
