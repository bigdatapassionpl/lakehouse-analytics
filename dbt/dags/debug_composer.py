# dags/debug_env.py
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import os
import sys

def debug_env():
    print(f"Airflow Home: {os.environ.get('AIRFLOW_HOME', '/home/airflow')}")
    print(f"Python Path: {sys.path}")
    print(f"DAGs Dir Contents: {os.listdir('/home/airflow/gcs/dags')}")
    # print(f"Current User: {os.getlogin()}")
    # with open('/proc/cpuinfo', 'r') as f:
    #     print(f"CPU Info: {f.read()}")

with DAG(
    dag_id='debug_env',
    start_date=datetime(2025, 2, 23),
    schedule_interval=None,
    catchup=False,
) as dag:
    task = PythonOperator(
        task_id='debug',
        python_callable=debug_env,
    )
