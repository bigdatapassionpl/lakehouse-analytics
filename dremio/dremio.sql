
SELECT * FROM Snowflake.CITIBIKE.PUBLIC.TRIPS LIMIT 10;

SELECT * FROM Postgresql.public.customers LIMIT 10;

SELECT COUNT(*) from Postgresql.public.customers as customers;

SELECT *
from Postgresql.public.customers as customers
WHERE  customers.id = 15771;





SELECT *
from Snowflake.CITIBIKE.PUBLIC.TRIPS as trips
FULL join Postgresql.public.customers as customers ON CAST(trips.bikeid AS INTEGER) = CAST(customers.id AS INTEGER)
WHERE trips.bikeid = 15771 OR customers.id = 15771
limit 100;

SELECT *
from (
    select * from
    Snowflake.CITIBIKE.PUBLIC.TRIPS
    trips.bikeid = 15771
) as trips
FULL join Postgresql.public.customers as customers
ON CAST(trips.bikeid AS INTEGER) = CAST(customers.id AS INTEGER)
WHERE trips.bikeid = 15771 OR customers.id = 15771
limit 100;

SELECT *
from Snowflake.CITIBIKE.PUBLIC.TRIPS as trips
FULL join Postgresql.public.customers as customers ON CAST(trips.bikeid AS INTEGER) = CAST(customers.id AS INTEGER)
WHERE trips.bikeid = 15771 OR customers.id = 15771
limit 100


SELECT *
from (
    select * from
    Snowflake.CITIBIKE.PUBLIC.TRIPS
    where trips.bikeid = 15771
) as trips
FULL JOIN  Postgresql.public.customers2 as customers
ON CAST(trips.bikeid AS INTEGER) = CAST(customers.id AS INTEGER)
WHERE trips.bikeid = 15771 OR customers.id = 15771
limit 10;