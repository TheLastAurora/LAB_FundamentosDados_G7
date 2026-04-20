#!/bin/bash
set -e

echo "Waiting for PostgreSQL to start..."
until pg_isready -U "$POSTGRES_USER"; do
  sleep 1
done

if [ ! -f /backups/litedb.tar ]; then
    echo "litedb.tar não encontrado em /backups/. Pulando restore."
    exit 0
fi

echo "Restoring database from backup..."

pg_restore \
  --username="$POSTGRES_USER" \
  --dbname="$POSTGRES_DB" \
  --verbose \
  /backups/litedb.tar

echo "Restore completed!"