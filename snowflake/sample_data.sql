
USE DATABASE "SNOWFLAKE_SAMPLE_DATA";

ALTER SESSION SET USE_CACHED_RESULT = TRUE;

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

