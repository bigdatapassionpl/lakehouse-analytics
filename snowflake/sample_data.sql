use database snowflake_sample_data;
use schema snowflake_sample_data.tpch_sf1000;


ALTER SESSION SET USE_CACHED_RESULT = FALSE;


SELECT avg(o_totalprice), max(o_orderdate), min(o_orderdate)
FROM ORDERS;

SELECT distinct o_orderstatus
FROM ORDERS;

SELECT distinct o_orderpriority
FROM ORDERS;


-- top 10 clients by value
SELECT sum(o_totalprice) as totalpricesum, count(1) as numberoforders, o.o_custkey
FROM ORDERS o
left join customer c on c.c_custkey = o.o_custkey
group by o_custkey
order by totalpricesum desc
limit 10;


-- better query and performance
select t1.totalpricesum, numberoforders, c.c_name, c.c_custkey
from (
  SELECT sum(o_totalprice) as totalpricesum, count(1) as numberoforders, o_custkey
    FROM ORDERS o
    group by o_custkey
) as t1
left join customer c on c.c_custkey = t1.o_custkey
order by totalpricesum desc
limit 10;

-- biggest client to variable
set biggestclientid=104056177;

--
select *
from orders o
left join lineitem l ON o_orderkey = l_orderkey
where o_custkey = $biggestclientid;


-- best products
select l_partkey, sum(l_quantity) as totalquantity, sum(l_extendedprice) as totalprice, count(1) as totalorders
from lineitem l
group by l_partkey
order by totalprice desc
limit 10;


-- best suppliers
select l_suppkey, sum(l_quantity) as totalquantity, sum(l_extendedprice) as totalprice, count(1) as totalorders
from lineitem l
group by l_suppkey
order by totalprice desc
limit 10;

-- part vs supplier
select ps_partkey, count(*) as numberofsuppliers
from partsupp
group by ps_partkey
order by numberofsuppliers desc, ps_partkey desc
limit 10;

set partkey = 20000000;
select l_extendedprice / l_quantity, l.*
from partsupp ps
left join part p on p_partkey = ps_partkey
left join supplier s on ps_suppkey = s_suppkey
left join lineitem l on (l_partkey = ps_partkey and l_suppkey = ps_suppkey)
where p_partkey = $partkey
limit 100;


-- The query lists totals for extended price, discounted extended price, discounted extended price plus tax, average quantity, average extended price, and average discount.
-- These aggregates are grouped by RETURNFLAG and LINESTATUS, and listed in ascending order of RETURNFLAG and LINESTATUS.
-- A count of the number of line items in each group is included:
select
       l_returnflag,
       l_linestatus,
       sum(l_quantity) as sum_qty,
       sum(l_extendedprice) as sum_base_price,
       sum(l_extendedprice * (1-l_discount)) as sum_disc_price,
       sum(l_extendedprice * (1-l_discount) * (1+l_tax)) as sum_charge,
       avg(l_quantity) as avg_qty,
       avg(l_extendedprice) as avg_price,
       avg(l_discount) as avg_disc,
       count(*) as count_order
 from
       lineitem
 where
       l_shipdate <= dateadd(day, -90, to_date('1998-12-01'))
 group by
       l_returnflag,
       l_linestatus
 order by
       l_returnflag,
       l_linestatus;


SELECT "NATION"."N_NAME" AS "N_NAME"
FROM "TPCH_SF1000"."ORDERS" "ORDERS"
  LEFT JOIN "TPCH_SF1000"."CUSTOMER" "CUSTOMER" ON ("ORDERS"."O_CUSTKEY" = "CUSTOMER"."C_CUSTKEY")
  LEFT JOIN "TPCH_SF1000"."NATION" "NATION" ON ("CUSTOMER"."C_NATIONKEY" = "NATION"."N_NATIONKEY")
GROUP BY 1;


select
    c_custkey
    ,c_name
    ,sum(c_acctbal)
from "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF10"."CUSTOMER"
group by 1,2;


select
    c.c_custkey
    ,c.c_name
    ,c.c_acctbal
    ,o.o_orderkey
    ,o.o_orderstatus
    ,o.o_totalprice
from "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF10"."CUSTOMER" as c
left join "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF10"."ORDERS" as o on c.c_custkey=o.o_custkey
where c_custkey='1369097';


SELECT r.r_name, r2.r_name
FROM "PUBLIC"."LINEITEM" l
  LEFT JOIN "PUBLIC"."ORDERS" "ORDERS" ON ("ORDERS"."O_ORDERKEY" = l."L_ORDERKEY")

  LEFT JOIN "PUBLIC"."CUSTOMER" "CUSTOMER" ON ("ORDERS"."O_CUSTKEY" = "CUSTOMER"."C_CUSTKEY")
  LEFT JOIN "PUBLIC"."NATION" n ON ("CUSTOMER"."C_NATIONKEY" = n.n_nationkey)
  LEFT JOIN "PUBLIC"."REGION" r ON (n."N_REGIONKEY" = r.r_regionkey)

  LEFT JOIN "PUBLIC"."PARTSUPP" ps ON (ps_partkey = l_partkey AND ps_suppkey = l_suppkey)
  LEFT JOIN "PUBLIC"."SUPPLIER" s ON (ps_suppkey = s_suppkey)
  LEFT JOIN nation n2 on (n2.n_nationkey = s.s_nationkey)
  LEFT JOIN region r2 on (r2.r_regionkey = n2.n_regionkey)

where r.r_regionkey != r2.r_regionkey

LIMIT 10;

