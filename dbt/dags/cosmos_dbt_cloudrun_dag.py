import os
from pathlib import Path

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from pendulum import datetime
from airflow.datasets import Dataset

from cosmos import DbtTaskGroup, ProjectConfig, ExecutionConfig, ProfileConfig
from cosmos.constants import ExecutionMode
from cosmos.operators import DbtRunOperationOperator, DbtSeedOperator
from cosmos.profiles import SnowflakeUserPasswordProfileMapping
from cosmos.profiles import SnowflakePrivateKeyPemProfileMapping

DEFAULT_DBT_ROOT_PATH = Path(__file__).parent / "dbt"
DBT_ROOT_PATH = Path(os.getenv("DBT_ROOT_PATH", DEFAULT_DBT_ROOT_PATH))

GCP_PROJECT_ID = "bigdataworkshops"
GCP_LOCATION = "europe-central2"
GCP_CLOUD_RUN_JOB_NAME = "astronomer-cosmos-example"

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

project_config = ProjectConfig(
    dbt_project_path="/home/airflow/gcs/dags/jaffle_shop",
    manifest_path="/home/airflow/gcs/dags/jaffle_shop/target/manifest.json",
)

execution_config = ExecutionConfig(
    execution_mode=ExecutionMode.GCP_CLOUD_RUN_JOB,
)

with DAG(
    dag_id="cosmos_dbt_cloudrun_dag",
    start_date=datetime(2022, 11, 27),
    schedule=None,
    catchup=False,
) as dag:

    pre_dbt_workflow = EmptyOperator(task_id="pre_dbt_workflow")

    # pre_dbt_workflow = DbtSeedOperator(
    #     task_id="seed_jaffle_shop",
    #     project_dir="/home/airflow/gcs/dags/jaffle_shop",
    #     outlets=[Dataset("SEED://JAFFLE_SHOP")],
    #     profile_config=profile_config,
    #     install_deps=True,
    # )

    jaffle_shop = DbtTaskGroup(
        group_id="jaffle_shop",
        project_config=project_config,
        execution_config=execution_config,
        operator_args={
            "project_id": GCP_PROJECT_ID,
            "region": GCP_LOCATION,
            "job_name": GCP_CLOUD_RUN_JOB_NAME,
            },
        default_args={"retries": 0},
        dag=dag,
    )

    post_dbt_workflow = EmptyOperator(task_id="post_dbt_workflow")

pre_dbt_workflow >> jaffle_shop >> post_dbt_workflow