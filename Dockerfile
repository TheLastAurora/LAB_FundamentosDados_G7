FROM apache/airflow:2.10.5-python3.11
USER airflow
COPY --chown=airflow:airflow extraction/ /opt/airflow/extraction/
COPY --chown=airflow:airflow pyproject.toml /opt/airflow/
RUN pip install --no-cache-dir .
