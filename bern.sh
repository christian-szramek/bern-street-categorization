#!/bin/bash

# TODO improve this
export PGPASSWORD="osmissoocool"

WORK_DIR=$(pwd)

./download/download.sh $WORK_DIR Bern https://download.geofabrik.de/europe/switzerland-latest.osm.pbf https://www.openstreetmap.org/api/0.6/relation/1682378/full
./import/import.sh $WORK_DIR Bern
