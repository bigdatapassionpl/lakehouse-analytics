from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.constants import ExecutionMode
from cosmos.profiles import PostgresUserPasswordProfileMapping
from datetime import datetime

profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="airflow_db",
        profile_args={"schema": "public"},
    ),
)

my_cosmos_dag = DbtDag(
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
    ),
    operator_args={
        "py_system_site_packages": False,
        "py_requirements": ["dbt-snowflake"],
    },
    # normal dag parameters
    schedule_interval="@daily",
    start_date=datetime(2023, 1, 1),
    catchup=False,
    dag_id="my_cosmos_dag",
    default_args={"retries": 0},
)