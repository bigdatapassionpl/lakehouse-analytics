"""
PyIceberg script to create table in catalog
Usage: python create_example_table_in_catalog.py <config_name> <table_name>
Example: python create_example_table_in_catalog.py snowflake example_namespace.users
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
import sys
import pyarrow as pa
from datetime import datetime, timedelta
import random

# Parse command-line arguments
if len(sys.argv) != 3:
    print("Usage: python create_example_table_in_catalog.py <config_name> <table_name>")
    print("Example: python create_example_table_in_catalog.py snowflake example_namespace.users")
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

# Define schema for example table
schema = Schema(
    NestedField(1, "id", LongType(), required=True),
    NestedField(2, "name", StringType(), required=False),
    NestedField(3, "email", StringType(), required=False),
    NestedField(4, "age", LongType(), required=False),
    NestedField(5, "salary", DoubleType(), required=False),
    NestedField(6, "created_at", TimestampType(), required=False),
)

# Extract namespace from table_name
if '.' not in table_name:
    print(f"Error: Table name must include namespace (e.g., namespace.table)")
    sys.exit(1)

namespace = table_name.split('.')[0]

# Create namespace first
try:
    catalog.create_namespace(namespace)
    print(f"Namespace created: {namespace}")
except Exception as e:
    print(f"Namespace creation (may already exist): {e}")

try:
    table = catalog.create_table(
        identifier=table_name,
        schema=schema,
    )
    print(f"Table created successfully: {table_name}")
    print(f"Schema: {table.schema()}")

    # Generate 10 fake random rows
    first_names = ["John", "Jane", "Bob", "Alice", "Charlie", "Diana", "Eve", "Frank", "Grace", "Henry"]
    last_names = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez"]

    data = {
        "id": list(range(1, 11)),
        "name": [f"{random.choice(first_names)} {random.choice(last_names)}" for _ in range(10)],
        "email": [f"user{i}@example.com" for i in range(1, 11)],
        "age": [random.randint(22, 65) for _ in range(10)],
        "salary": [round(random.uniform(50000, 150000), 2) for _ in range(10)],
        "created_at": [datetime.now() - timedelta(days=random.randint(0, 365)) for _ in range(10)],
    }

    # Convert to PyArrow table with explicit schema
    arrow_schema = pa.schema([
        pa.field("id", pa.int64(), nullable=False),
        pa.field("name", pa.string(), nullable=True),
        pa.field("email", pa.string(), nullable=True),
        pa.field("age", pa.int64(), nullable=True),
        pa.field("salary", pa.float64(), nullable=True),
        pa.field("created_at", pa.timestamp('us'), nullable=True),
    ])
    arrow_table = pa.Table.from_pydict(data, schema=arrow_schema)

    # Insert data into Iceberg table
    table.append(arrow_table)
    print(f"Inserted 10 rows into {table_name}")

except Exception as e:
    print(f"Error creating table: {e}")