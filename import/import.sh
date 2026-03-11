#!/bin/bash

source "utils.sh"

check_lua_script_env_variable_exists
check_db_variables_exist
check_restriction_env_variable_exists

WORK_DIR=$1
TMP_DIR=$2

osm2pgsql  \
--host $PG_HOST \
--database $PG_DB \
--port $PG_PORT \
--user $PG_USER \
--output=flex \
--style="$WORK_DIR/import/flex/$LUA_SCRIPT" \
--slim \
--drop \
"$TMP_DIR/final.osm.pbf"