#!/bin/bash

WORK_DIR=$(pwd)

./import/prepare.sh $WORK_DIR Bern https://download.geofabrik.de/europe/switzerland-latest.osm.pbf https://www.openstreetmap.org/api/0.6/relation/1682378/full
./processing/processing.sh $WORK_DIR Bern
