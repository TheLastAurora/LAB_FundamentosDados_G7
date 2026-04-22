import great_expectations as gx
from sqlalchemy import create_engine

# ==========================================
# Conexão com Postgres
# ==========================================
connection_string = "postgresql+psycopg2://postgres:postgres@postgres:5432/airflow"

# ==========================================
# Inicializa contexto
# ==========================================
context = gx.get_context()

# ==========================================
# Cria datasource (API nova)
# ==========================================
datasource_name = "postgres_datasource"

datasource = context.sources.add_or_update_postgres(
    name=datasource_name,
    connection_string=connection_string,
)

# ==========================================
# Cria asset (tabela raw.artists)
# ==========================================
table_name = "artists"

asset = datasource.add_table_asset(
    name=table_name,
    table_name=table_name,
    schema_name="raw",
)

# ==========================================
# Batch
# ==========================================
batch_request = asset.build_batch_request()

validator = context.get_validator(
    batch_request=batch_request,
    expectation_suite_name="artists_suite",
)

# ==========================================
# Expectations
# ==========================================
validator.expect_table_row_count_to_be_between(min_value=1)
validator.expect_column_values_to_not_be_null("id")
validator.expect_column_values_to_be_unique("id")

# ==========================================
# Salva suite
# ==========================================
validator.save_expectation_suite(discard_failed_expectations=False)

# ==========================================
# Executa validação
# ==========================================
results = validator.validate()

if not results["success"]:
    raise Exception("Validação falhou!")

print("Validação GE executada com sucesso!")