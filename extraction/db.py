from __future__ import annotations

import sqlalchemy
from sqlalchemy import text
from sqlalchemy.engine import Engine

from extraction.settings import PostgresSettings


def build_engine(s: PostgresSettings) -> Engine:
    url = f"postgresql+psycopg2://{s.user}:{s.password}@{s.host}:{s.port}/{s.database}"
    return sqlalchemy.create_engine(url, pool_pre_ping=True)


def ensure_schema(engine: Engine, schema: str) -> None:
    with engine.begin() as conn:
        conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{schema}"'))
