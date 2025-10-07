"""
PyIceberg script to read table from catalog
Usage: python read_table_using_iceberg_rest_catalog.py <config_name> <table_name>
Example: python read_table_using_iceberg_rest_catalog.py databricks radek.default.customer
"""
from pyiceberg.catalog import load_catalog
import pyarrow as pa
import yaml
import os
import sys

# Parse command-line arguments
if len(sys.argv) != 3:
    print("Usage: python read_table_using_iceberg_rest_catalog.py <config_name> <table_name>")
    print("Example: python read_table_using_iceberg_rest_catalog.py databricks radek.default.customer")
    sys.exit(1)

config_name = sys.argv[1]
table_name = sys.argv[2]

# Load catalog configuration from YAML file
config_path = os.path.expanduser("~/catalog_config.yaml")
with open(config_path, 'r') as f:
    config = yaml.safe_load(f)

# Configure catalog connection
if config_name not in config:
    print(f"Error: Config '{config_name}' not found in {config_path}")
    print(f"Available configs: {', '.join(config.keys())}")
    sys.exit(1)

catalog = load_catalog(config_name, **config[config_name])

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
