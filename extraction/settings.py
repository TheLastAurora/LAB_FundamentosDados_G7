from __future__ import annotations

import os
from dataclasses import dataclass

from dotenv import load_dotenv


@dataclass
class PostgresSettings:
    host: str
    port: int
    database: str
    user: str
    password: str
    target_schema: str
    chunksize: int


def load_settings() -> PostgresSettings:
    load_dotenv()
    return PostgresSettings(
        host=os.getenv("POSTGRES_HOST", "localhost"),
        port=int(os.getenv("POSTGRES_PORT", "5432")),
        database=os.getenv("POSTGRES_DB", "postgres"),
        user=os.getenv("POSTGRES_USER", "postgres"),
        password=os.getenv("POSTGRES_PASSWORD", "postgres"),
        target_schema=os.getenv("TARGET_SCHEMA", "raw"),
        chunksize=int(os.getenv("EXTRACTION_CHUNKSIZE", "100000")),
    )
