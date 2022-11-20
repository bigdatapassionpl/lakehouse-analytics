
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
~~~