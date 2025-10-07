
# Reading Databricks Unity catalog tables (Uniform)
~~~shell
python pyiceberg/read_table_from_catalog.py databricks radek.default.customer
~~~

# Create Iceberg Table using Iceberg REST Catalog
~~~shell
python pyiceberg/create_example_table_in_catalog.py snowflake example_namespace.example_users
~~~

# Reading Snowfalke Open Data catalog tables
~~~shell
python pyiceberg/read_table_from_catalog.py snowflake example_namespace.example_users
~~~

# Drop Snowfalke Open Data catalog tables
~~~shell
python pyiceberg/drop_table_in_catalog.py snowflake example_namespace.example_users
~~~
