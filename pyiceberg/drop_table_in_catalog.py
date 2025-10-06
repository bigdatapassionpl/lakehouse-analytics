"""
PyIceberg script to delete table from catalog
Usage: python delete_table_in_catalog.py <config_name> <table_name>
Example: python delete_table_in_catalog.py snowflake example_namespace.test_users
"""
from pyiceberg.catalog import load_catalog
import yaml
import os
import sys

# Parse command-line arguments
if len(sys.argv) != 3:
    print("Usage: python delete_table_in_catalog.py <config_name> <table_name>")
    print("Example: python delete_table_in_catalog.py snowflake example_namespace.test_users")
    sys.exit(1)

config_name = sys.argv[1]
table_name = sys.argv[2]

# Load catalog configuration from YAML file
config_path = os.path.expanduser("~/.snowflake/catalog_config.yaml")
with open(config_path, 'r') as f:
    config = yaml.safe_load(f)

# Configure catalog connection
if config_name not in config:
    print(f"Error: Config '{config_name}' not found in {config_path}")
    print(f"Available configs: {', '.join(config.keys())}")
    sys.exit(1)

catalog = load_catalog(config_name, **config[config_name])

# Delete table
try:
    catalog.drop_table(table_name)
    print(f"Table '{table_name}' deleted successfully from '{config_name}' catalog")
except Exception as e:
    print(f"Error deleting table: {e}")
    sys.exit(1)