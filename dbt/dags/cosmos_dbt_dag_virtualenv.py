from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.constants import ExecutionMode
from cosmos.constants import InvocationMode
from cosmos.profiles import SnowflakeUserPasswordProfileMapping
from cosmos.profiles import SnowflakePrivateKeyPemProfileMapping
from datetime import datetime
from pathlib import Path

profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_default",
        profile_args={"schema": "public"},
    ),
    # profile_mapping=SnowflakePrivateKeyPemProfileMapping(
    #     conn_id="snowflake_default",
    #     profile_args={"schema": "public"},
    # ),
)

cosmos_dbt_dag_virtualenv = DbtDag(
    # project_config=ProjectConfig(
    #     "/jaffle_shop",
    # ),
    # project_config=ProjectConfig(
    #     dbt_project_path="/usr/local/airflow/dags/jaffle_shop",
    #     manifest_path="/usr/local/airflow/dags/jaffle_shop/target/manifest.json",
    # ),
    project_config=ProjectConfig(
        dbt_project_path="/home/airflow/gcs/dags/jaffle_shop",
        manifest_path="/home/airflow/gcs/dags/jaffle_shop/target/manifest.json",
    ),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        execution_mode=ExecutionMode.VIRTUALENV,
        virtualenv_dir=Path("/tmp/dbt-cosmos-shared-venv"),
    ),
    operator_args={
        "py_system_site_packages": False,
        "py_requirements": ["dbt-snowflake"],
    },
    # normal dag parameters
    # schedule_interval="@daily",
    schedule_interval=None,
    start_date=datetime(2025, 1, 1),
    catchup=False,
    dag_id="cosmos_dbt_dag_virtualenv",
    default_args={"retries": 0},
)
