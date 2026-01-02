#!/bin/bash

WORK_DIR=$1
CITY_NAME=$2

osm2pgsql  \
--host localhost \
--database osm \
--user osm_user \
--password \
--output=flex \
--style="$WORK_DIR/import/street_segments.lua" \
--slim \
--prefix "$CITY_NAME" \
"$WORK_DIR/$CITY_NAME.osm.pbf"

rm "$WORK_DIR/$CITY_NAME.osm.pbf"