from __future__ import annotations

import csv
import logging
import os
import re
import tarfile
import time
from dataclasses import dataclass

import pandas as pd
from sqlalchemy import text
from sqlalchemy.engine import Engine

from extraction.db import build_engine, ensure_schema
from extraction.settings import load_settings

log = logging.getLogger(__name__)


@dataclass
class TableLoadResult:
    table: str
    rows_loaded: int
    elapsed_seconds: float


def parse_restore_sql(tar: tarfile.TarFile) -> list[tuple[list[str], str]]:
    f = tar.extractfile("restore.sql")
    assert f is not None, "restore.sql not found in tar archive"
    content = f.read().decode("utf-8")
    result, seen = [], set()
    for line in content.splitlines():
        m = re.match(r"COPY\s+[\w.]+\s*\(([^)]+)\)\s+FROM\s+'(.+\.dat)'\s*;", line)
        if m:
            fname = m.group(2).split("/")[-1]
            if fname not in seen:
                seen.add(fname)
                cols = [c.strip().strip('"') for c in m.group(1).split(",")]
                result.append((cols, fname))
    return result


def load_table(
    engine: Engine, table: str, columns: list[str], dat_file: str, chunksize: int
) -> TableLoadResult:
    log.info(f"Loading {table} from {dat_file} ({len(columns)} cols)")
    tar_path = os.getenv("TAR_PATH", "./backups/litedb.tar")
    start = time.perf_counter()

    with engine.begin() as conn:
        conn.execute(text(f'DROP TABLE IF EXISTS raw."{table}"'))

    def _read_and_load(enc: str | None = None):
        nonlocal rows, chunk_n
        with tarfile.open(tar_path) as t:
            f = t.extractfile(dat_file)
            kwargs = dict(
                sep="\t",
                header=None,
                names=columns,
                na_values=["\\N"],
                chunksize=chunksize,
                engine="python",
                on_bad_lines="warn",
                quoting=csv.QUOTE_NONE,
            )
            if enc:
                kwargs["encoding"] = enc
            reader = pd.read_csv(f, **kwargs) # type: ignore
            with engine.begin() as conn:
                for df in reader:
                    chunk_n += 1
                    rows += len(df)
                    df.to_sql(
                        table,
                        conn,
                        schema="raw",
                        if_exists="append",
                        index=False,
                        method="multi",
                    )
                    log.info(f"  {table} chunk={chunk_n} rows={len(df)} so_far={rows}")

    rows, chunk_n = 0, 0
    try:
        _read_and_load()
    except UnicodeDecodeError:
        log.warning(f"UTF-8 failed for {dat_file}, retrying latin-1")
        _read_and_load("latin-1")

    elapsed = time.perf_counter() - start
    log.info(f"  {table} done: {rows} rows in {elapsed:.1f}s")
    return TableLoadResult(table, rows, elapsed)


def run_extraction() -> list[TableLoadResult]:
    logging.basicConfig(
        level=logging.INFO, format="%(asctime)s | %(levelname)s | %(message)s"
    )
    settings = load_settings()
    engine = build_engine(settings)
    ensure_schema(engine, settings.target_schema)

    tar_path = os.getenv("TAR_PATH", "./backups/litedb.tar")
    with tarfile.open(tar_path) as tar:
        tables = parse_restore_sql(tar)

    if not tables:
        log.error("No tables found in restore.sql")
        return []

    log.info(f"Found {len(tables)} tables to load into raw schema")
    results = []
    for i, (columns, dat_file) in enumerate(tables, 1):
        table = dat_file.replace(".dat", "")
        log.info(f"[{i}/{len(tables)}] {table}")
        try:
            results.append(
                load_table(engine, table, columns, dat_file, settings.chunksize)
            )
        except Exception as e:
            log.error(f"Failed to load {table}: {e}")
            raise

    total_rows = sum(r.rows_loaded for r in results)
    total_time = sum(r.elapsed_seconds for r in results)
    log.info(f"EL raw complete | tables={len(results)} total_rows={total_rows} total_elapsed={total_time:.1f}s")
    return results
