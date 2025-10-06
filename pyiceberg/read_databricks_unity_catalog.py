"""
PyIceberg script to read table from Databricks using Unity Catalog
"""
from pyiceberg.catalog import load_catalog
import pyarrow as pa
import configparser
import os

# Read Databricks configuration from ~/.databrickscfg
config = configparser.ConfigParser()
config_path = os.path.expanduser("~/.databrickscfg")
config.read(config_path)

# Use DEFAULT profile or specify another profile
profile = "DEFAULT"
host = config[profile]["host"]
token = config[profile]["token"]

# Configure Databricks Unity Catalog connection
catalog = load_catalog(
    "databricks",
    **{
        "type": "rest",
        "uri": f"{host}/api/2.1/unity-catalog/iceberg",
        "token": token,
    }
)

# Specify the table in Unity Catalog format: catalog.schema.table
table_name = "radek.default.customer"

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