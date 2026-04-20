FROM apache/airflow:3.2.0-python3.13

USER airflow

COPY airflow/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Extraction layer (EL)
COPY --chown=airflow:airflow extraction/ /opt/airflow/extraction/
COPY --chown=airflow:airflow pyproject.toml /opt/airflow/
RUN pip install --no-cache-dir /opt/airflow/
