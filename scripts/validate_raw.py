import great_expectations as gx
from sqlalchemy import create_engine

# ==========================================
# Conexão com Postgres (Docker network)
# ==========================================
connection_string = "postgresql+psycopg2://postgres:postgres@postgres:5432/airflow"

engine = create_engine(connection_string)

# ==========================================
# Inicializa contexto GE
# ==========================================
context = gx.get_context()

# ==========================================
# Cria datasource (se não existir)
# ==========================================
datasource_name = "postgres_datasource"

if datasource_name not in [ds["name"] for ds in context.list_datasources()]:
    context.sources.add_sqlalchemy(
        name=datasource_name,
        connection_string=connection_string,
    )

# ==========================================
# Cria asset (tabela raw.artists como exemplo)
# ==========================================
table_name = "artists"

asset = context.sources.get(datasource_name).add_table_asset(
    name=table_name,
    table_name=table_name,
    schema_name="raw",
)

# ==========================================
# Batch request
# ==========================================
batch_request = asset.build_batch_request()

validator = context.get_validator(
    batch_request=batch_request,
    expectation_suite_name="artists_suite",
)

# ==========================================
# Expectations básicas
# ==========================================
validator.expect_table_row_count_to_be_between(min_value=1)

validator.expect_column_values_to_not_be_null("id")

validator.expect_column_values_to_be_unique("id")

# ==========================================
# Salva suite
# ==========================================
validator.save_expectation_suite(discard_failed_expectations=False)

# ==========================================
# Roda validação
# ==========================================
results = validator.validate()

if not results["success"]:
    raise Exception("Validação falhou!")

print("Validação GE executada com sucesso!")