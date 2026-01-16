#!/bin/bash

WORK_DIR=$1
TMP_DIR=$2

osm2pgsql  \
--host $PGHOST \
--database $TARGET_DB \
--user $PGUSER \
--output=flex \
--style="$WORK_DIR/import/flex/$LUA_SCRIPT" \
--slim \
--drop \
"$TMP_DIR/final.osm.pbf"