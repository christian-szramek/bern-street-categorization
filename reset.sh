#!/bin/bash

source "utils.sh"

load_env_variables
check_db_variables_exist
check_maintenance_db_env_variable_exist

echo "Recreating database '${PG_DB}'..."

# Drop and recreate database
psql \
  --host="$PG_HOST" \
  --port="$PG_PORT" \
  --username="$PG_USER" \
  --dbname="$PG_MAINTENANCE_DB" \
  --set=ON_ERROR_STOP=on <<EOF

-- Terminate existing connections
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '${PG_DB}'
  AND pid <> pg_backend_pid();

-- Drop and recreate database
DROP DATABASE IF EXISTS ${PG_DB};
CREATE DATABASE ${PG_DB};

EOF

# Enable PostGIS extension in the new database
psql \
  --host="$PG_HOST" \
  --port="$PG_PORT" \
  --username="$PG_USER" \
  --dbname="$PG_DB" \
  --set=ON_ERROR_STOP=on <<EOF

CREATE EXTENSION IF NOT EXISTS postgis;

EOF

echo "Database '${PG_DB}' recreated and PostGIS enabled successfully."