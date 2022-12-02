use schema snowflake_warehouse.public;

-- Query the top 10 departure cities by number of total departures
SELECT origin, count(*) AS total_departures
FROM flight
WHERE year >= '2000'
GROUP BY origin
ORDER BY total_departures DESC
LIMIT 10;

-- Query the top 10 routes delayed by more than 1 hour:
SELECT origin, dest, count(*) as delays
FROM flight
WHERE depdelayminutes > 60
GROUP BY origin, dest
ORDER BY 3 DESC
LIMIT 10;