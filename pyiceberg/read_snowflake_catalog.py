"""
PyIceberg script to read table from Snowflake Open Catalog
"""
from pyiceberg.catalog import load_catalog
import pyarrow as pa
import yaml
import os

# Load catalog configuration from YAML file
config_path = os.path.expanduser("~/.snowflake/catalog_config.yaml")
with open(config_path, 'r') as f:
    config = yaml.safe_load(f)

# Configure Snowflake Open Catalog connection
catalog = load_catalog("snowflake", **config["snowflake"])

# Specify the table in Snowflake format: namespace.table
table_name = "example_namespace.users"

# Load the table
table = catalog.load_table(table_name)

# Read the table as PyArrow Table
arrow_table = table.scan().to_arrow()

# Display table info
print(f"Table: {table_name}")
print(f"Schema: {table.schema()}")
print(f"Rows: {len(arrow_table)}")
print(f"\nFirst 10 rows:")
print(arrow_table.slice(0, 10).to_pandas())

# Optional: Read with filters
# filtered_data = table.scan(
#     row_filter="field_name > 100"
# ).to_arrow()

# Optional: Select specific columns
# selected_columns = table.scan(
#     selected_fields=("column1", "column2")
# ).to_arrow()