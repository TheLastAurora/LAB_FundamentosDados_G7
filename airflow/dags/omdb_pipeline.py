"""
OMDB Pipeline DAG
=================
Orquestra o pipeline ELT completo:
  1. Extract & Load (CSV → raw)
  2. Great Expectations (validação da raw)
  3. dbt deps (instala pacotes)
  4. dbt run (raw → silver → gold)
  5. dbt test (testes genéricos + singulares)
"""

from datetime import datetime, timedelta

from airflow.sdk import DAG, dag
from airflow.providers.standard.operators.bash import BashOperator

default_args = {
    "owner": "grupo7",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id="omdb_pipeline",
    default_args=default_args,
    description="Pipeline ELT completo - OMDB (Grupo 7)",
    schedule="@daily",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["omdb", "elt", "grupo7"],
) as dag:

    # ----------------------------------------------------------
    # 1. Extract & Load: CSV → raw schema
    # ----------------------------------------------------------
    extract_load = BashOperator(
        task_id="extract_load",
        bash_command="python /opt/airflow/scripts/extract_load.py",
    )

    # ----------------------------------------------------------
    # 2. Great Expectations: validação da camada raw
    # ----------------------------------------------------------
    validate_raw = BashOperator(
        task_id="validate_raw",
        bash_command="python /opt/airflow/scripts/validate_raw.py",
    )

    # ----------------------------------------------------------
    # 3. dbt deps: instala pacotes (dbt_utils)
    # ----------------------------------------------------------
    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command="cd /opt/airflow/dbt && dbt deps --profiles-dir .",
    )

    # ----------------------------------------------------------
    # 4. dbt run: transforma raw → silver → gold
    # ----------------------------------------------------------
    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="cd /opt/airflow/dbt && dbt run --profiles-dir .",
    )

    # ----------------------------------------------------------
    # 5. dbt test: executa testes genéricos e singulares
    # ----------------------------------------------------------
    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="cd /opt/airflow/dbt && dbt test --profiles-dir .",
    )

    # ----------------------------------------------------------
    # Dependências da DAG
    # ----------------------------------------------------------
    extract_load >> validate_raw >> dbt_deps >> dbt_run >> dbt_test
