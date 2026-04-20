"""
OMDB Pipeline DAG
=================
Orquestra o pipeline ELT completo:
  1. Extract & Load (litedb.tar → raw)
  2. Great Expectations (validação da raw)
  3. dbt deps (instala pacotes)
  4. dbt run (raw → silver → gold)
  5. dbt test (testes genéricos + singulares)
"""

from datetime import datetime, timedelta

from airflow.sdk import DAG
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
    max_active_runs=1,
    tags=["omdb", "elt", "grupo7"],
) as dag:

    # ----------------------------------------------------------
    # 1. Extract & Load: litedb.tar → raw schema
    # ----------------------------------------------------------
    extract_load = BashOperator(
        task_id="extract_load",
        bash_command="python -m extraction",
    )

    # ----------------------------------------------------------
    # 2. Rename: OIDs numéricos → nomes reais de tabela
    # ----------------------------------------------------------
    rename_tables = BashOperator(
        task_id="rename_tables",
        bash_command="""
            export PGPASSWORD="$POSTGRES_PASSWORD"
            psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<'SQL'
            DO $$
            DECLARE
                mapping TEXT[][] := ARRAY[
                    ['3701','artists'],
                    ['3702','albums'],
                    ['3703','playbacks'],
                    ['3704','tracks'],
                    ['3705','album_relation'],
                    ['3706','artist_album'],
                    ['3707','artist_track'],
                    ['3708','features_track']
                ];
                r TEXT[];
            BEGIN
                FOREACH r SLICE 1 IN ARRAY mapping LOOP
                    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='raw' AND table_name=r[1])
                    AND NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='raw' AND table_name=r[2]) THEN
                        EXECUTE format('ALTER TABLE raw.%I RENAME TO %I', r[1], r[2]);
                        RAISE NOTICE 'Renamed raw.% -> raw.%', r[1], r[2];
                    END IF;
                END LOOP;
            END $$;
            SQL
        """,
    )

    # ----------------------------------------------------------
    # 3. Great Expectations: validação da camada raw
    # ----------------------------------------------------------
    validate_raw = BashOperator(
        task_id="validate_raw",
        bash_command="python /opt/airflow/scripts/validate_raw.py",
    )

    # ----------------------------------------------------------
    # 4. dbt deps: instala pacotes (dbt_utils)
    # ----------------------------------------------------------
    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command="cd /opt/airflow/dbt && dbt deps --profiles-dir .",
    )

    # ----------------------------------------------------------
    # 5. dbt run: transforma raw → silver → gold
    # ----------------------------------------------------------
    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="cd /opt/airflow/dbt && dbt run --profiles-dir .",
    )

    # ----------------------------------------------------------
    # 6. dbt test: executa testes genéricos e singulares
    # ----------------------------------------------------------
    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="cd /opt/airflow/dbt && dbt test --profiles-dir .",
    )

    # ----------------------------------------------------------
    # Dependências da DAG
    # ----------------------------------------------------------
    extract_load >> rename_tables >> validate_raw >> dbt_deps >> dbt_run >> dbt_test
