import great_expectations as gx

# ==========================================
# Configuração
# ==========================================
connection_string = "postgresql+psycopg2://postgres:postgres@postgres:5432/airflow"
datasource_name = "postgres_datasource"
schema_name = "raw"
table_name = "artists"
suite_name = "artists_suite"

# ==========================================
# Inicializa contexto
# ==========================================
context = gx.get_context()

# ==========================================
# Cria ou atualiza datasource
# ==========================================
datasource = context.sources.add_or_update_postgres(
    name=datasource_name,
    connection_string=connection_string,
)

# ==========================================
# Cria asset
# ==========================================
asset = datasource.add_table_asset(
    name=table_name,
    table_name=table_name,
    schema_name=schema_name,
)

# ==========================================
# Cria suite SE não existir
# ==========================================
try:
    context.get_expectation_suite(suite_name)
except Exception:
    context.add_expectation_suite(expectation_suite_name=suite_name)

# ==========================================
# Batch
# ==========================================
batch_request = asset.build_batch_request()

# ==========================================
# Validator (AGORA CORRETO)
# ==========================================
validator = context.get_validator(
    batch_request=batch_request,
    expectation_suite_name=suite_name,
)

# ==========================================
# Expectations
# ==========================================
validator.expect_table_row_count_to_be_between(min_value=1)
validator.expect_column_values_to_not_be_null("id")
validator.expect_column_values_to_be_unique("id")

# ==========================================
# Salva
# ==========================================
validator.save_expectation_suite(discard_failed_expectations=False)

# ==========================================
# Executa validação
# ==========================================
results = validator.validate()

if not results["success"]:
    raise Exception("Validação GE falhou!")

print("✅ Validação GE executada com sucesso!")