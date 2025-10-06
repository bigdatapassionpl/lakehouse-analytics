"""
PyIceberg script to create table in Snowflake Open Catalog (Polaris)
"""
from pyiceberg.catalog import load_catalog
from pyiceberg.schema import Schema
from pyiceberg.types import (
    NestedField,
    StringType,
    LongType,
    TimestampType,
    DoubleType,
)
import yaml
import os

# Load catalog configuration from YAML file
config_path = os.path.expanduser("~/.snowflake/catalog_config.yaml")
with open(config_path, 'r') as f:
    config = yaml.safe_load(f)

# Configure Snowflake Open Catalog connection
catalog = load_catalog("snowflake", **config["snowflake"])

# Define schema for example table
schema = Schema(
    NestedField(1, "id", LongType(), required=True),
    NestedField(2, "name", StringType(), required=False),
    NestedField(3, "email", StringType(), required=False),
    NestedField(4, "age", LongType(), required=False),
    NestedField(5, "salary", DoubleType(), required=False),
    NestedField(6, "created_at", TimestampType(), required=False),
)

# Create namespace first
namespace = "example_namespace"

try:
    catalog.create_namespace(namespace)
    print(f"Namespace created: {namespace}")
except Exception as e:
    print(f"Namespace creation (may already exist): {e}")

# Create table in namespace
table_name = f"{namespace}.users"

try:
    table = catalog.create_table(
        identifier=table_name,
        schema=schema,
    )
    print(f"Table created successfully: {table_name}")
    print(f"Schema: {table.schema()}")
except Exception as e:
    print(f"Error creating table: {e}")