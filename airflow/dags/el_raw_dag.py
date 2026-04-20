from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "vitor",
    "retries": 1,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id="el_raw_extraction",
    default_args=default_args,
    description="Extração EL do litedb.tar para schema raw",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["extraction", "raw"],
) as dag:
    extract = BashOperator(
        task_id="extract_to_raw",
        bash_command="python -m extraction",
    )
