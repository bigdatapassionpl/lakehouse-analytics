drop database if exists dbt_raw;
drop database if exists dbt_analytics;

create database dbt_raw;
create database dbt_analytics;

create schema dbt_raw.jaffle_shop;
create schema dbt_raw.stripe;

create table dbt_raw.jaffle_shop.customers
( id integer,
  first_name varchar,
  last_name varchar
);

copy into dbt_raw.jaffle_shop.customers (id, first_name, last_name)
from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1
  );

create table dbt_raw.jaffle_shop.orders
( id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);

copy into dbt_raw.jaffle_shop.orders (id, user_id, order_date, status)
from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1
  );


create table dbt_raw.stripe.payment
( id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);

copy into dbt_raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1
  );



select * from dbt_raw.jaffle_shop.customers;
select * from dbt_raw.jaffle_shop.orders;
select * from dbt_raw.stripe.payment;
