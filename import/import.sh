#!/bin/bash

WORK_DIR=$1

osm2pgsql  \
--host $PGHOST \
--database $TARGET_DB \
--user $PGUSER \
--output=flex \
--style="$WORK_DIR/import/street_segments.lua" \
--slim \
--prefix "$CITY_NAME" \
"$WORK_DIR/$CITY_NAME.osm.pbf"

rm "$WORK_DIR/$CITY_NAME.osm.pbf"