
# Lakehouse Analytics 
## Snowflake, Redshift, BigQuery, dbt, etc

### Przygotowanie dbt
~~~shell
cd dbt
rm -rf venv-dbt
python3 -m venv venv-dbt
python3.11 -m venv venv-dbt
source venv-dbt/bin/activate

pip list
pip install -r requirements.txt
pip list | grep dbt

python --version
dbt --version

deactivate
~~~

### SnowSQL
Linux/macOS ~/.snowsql/config
Windows %USERPROFILE%\.snowsql\config
~~~
[connections.my_example_connection]
accountname = myorganization-myaccount
username = jsmith
password = xxxxxxxxxxxxxxxxxxxx
dbname = mydb
schemaname = public
warehousename = mywh
~~~

~~~shell
snowsql -v
snowsql -a <account_name> -u <login_name>

export SNOW_CONNECTION=**********

snowsql -c $SNOW_CONNECTION -f snowflake/dbt/dbt_clean.sql
snowsql -c $SNOW_CONNECTION -f snowflake/dbt/dbt_init.sql
snowsql -c $SNOW_CONNECTION -f snowflake/dbt/dbt_jaffle_shop.sql
~~~

### DBT profiles.yml
Linux/macOS ~/.dbt/profiles.yml
Windows %USERPROFILE%\.dbt\profiles.yml
~~~
jaffle_shop:
  outputs:
    dev:
      account: myorganization-myaccount
      database: DBT_ANALYTICS
      password: **********
      role: DBT_ROLE
      schema: PUBLIC
      threads: 1
      type: snowflake
      user: DBT_USER
      warehouse: DBT_WH
  target: dev
~~~

### DBT commands
~~~shell
dbt debug
dbt seed
dbt run
dbt test
dbt docs generate
dbt docs serve
~~~