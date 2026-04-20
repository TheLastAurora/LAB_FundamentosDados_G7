#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE airflow OWNER postgres;
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'airflow') THEN
            CREATE ROLE airflow LOGIN PASSWORD 'airflow';
        END IF;
    END
    \$\$;
    GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;
    \c airflow
    GRANT ALL ON SCHEMA public TO airflow;
    ALTER SCHEMA public OWNER TO airflow;
EOSQL
