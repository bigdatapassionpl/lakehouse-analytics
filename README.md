
# Lakehouse Analytics 
## Snowflake, Redshift, BigQuery, dbt, etc

### Przygotowanie dbt
~~~
cd dbt
python3 -m venv venv-dbt
source venv-dbt/bin/activate

pip list
pip install -r requirements.txt
pip list | grep dbt

dbt --version
~~~

### SnowSQL
~~~
snowsql -v
snowsql -a <account_name> -u <login_name>

export SNOW_CONNECTION=**********

snowsql -c $SNOW_CONNECTION -f snowflake/dbt_clean.sql
snowsql -c $SNOW_CONNECTION -f snowflake/dbt_init.sql
snowsql -c $SNOW_CONNECTION -f snowflake/dbt_jaffle_shop.sql
~~~