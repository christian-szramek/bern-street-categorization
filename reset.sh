#!/usr/bin/bash

# Configuration (override via environment variables)
PGHOST=localhost
PGPORT=5432
PGUSER=osm_user
TARGET_DB=osm
MAINTENANCE_DB=postgres

# TODO improve this
export PGPASSWORD="osmissoocool"

echo "Recreating database '${TARGET_DB}'..."

# Drop and recreate database
psql \
  --host="$PGHOST" \
  --port="$PGPORT" \
  --username="$PGUSER" \
  --dbname="$MAINTENANCE_DB" \
  --set=ON_ERROR_STOP=on <<EOF

-- Terminate existing connections
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '${TARGET_DB}'
  AND pid <> pg_backend_pid();

-- Drop and recreate database
DROP DATABASE IF EXISTS ${TARGET_DB};
CREATE DATABASE ${TARGET_DB};

EOF

# Enable PostGIS extension in the new database
psql \
  --host="$PGHOST" \
  --port="$PGPORT" \
  --username="$PGUSER" \
  --dbname="$TARGET_DB" \
  --set=ON_ERROR_STOP=on <<EOF

CREATE EXTENSION IF NOT EXISTS postgis;

EOF

echo "Database '${TARGET_DB}' recreated and PostGIS enabled successfully."