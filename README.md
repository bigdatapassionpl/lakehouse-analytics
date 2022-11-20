
# Lakehouse Analytics 
## Snowflake, Redshift, BigQuery, dbt, etc

~~~
python3 -m  venv dbt-snowflake-venv
source dbt-snowflake-venv/bin/activate

pip list
pip install -r requirements.txt
pip list | grep dbt

dbt --version
~~~

~~~
snowsql -v
snowsql -a <account_name> -u <login_name>

export SNOW_CONNECTION=**********

snowsql -c $SNOW_CONNECTION -f snowflake/dbt_clean.sql
snowsql -c $SNOW_CONNECTION -f snowflake/dbt_init.sql
snowsql -c $SNOW_CONNECTION -f snowflake/dbt_jaffle_shop.sql
~~~