
# General
~~~shell
python script_name.py <caonfig_name> <namespace.table>
~~~

# Reading Databricks Unity catalog tables (Uniform)
~~~shell
python read_table_from_catalog.py databricks default.customer
~~~

# Create Iceberg Table using Iceberg REST Catalog
~~~shell
python create_example_table_in_catalog.py snowflake example_namespace.example_users
~~~

# Reading Snowfalke Open Data catalog tables
~~~shell
python read_table_from_catalog.py snowflake example_namespace.example_users
~~~

# Drop Snowfalke Open Data catalog tables
~~~shell
python drop_table_in_catalog.py snowflake example_namespace.example_users
~~~
