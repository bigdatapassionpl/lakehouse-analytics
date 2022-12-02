
-- drop database snowflake_warehouse;
-- create database snowflake_warehouse;
-- create database snowflake_bigdata;
-- drop database SNOWFLAKE_BIGDATA;

USE DATABASE "SNOWFLAKE_WAREHOUSE";
use schema snowflake_warehouse.public;

create or replace view customer as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;
create or replace view nation   as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.NATION;
create or replace view region   as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.REGION;
create or replace view orders   as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.ORDERS;
create or replace view lineitem as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.LINEITEM;
create or replace view part     as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.PART;
create or replace view partsupp as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.PARTSUPP;
create or replace view supplier as select * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.SUPPLIER;

