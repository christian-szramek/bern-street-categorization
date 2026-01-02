#!/bin/bash

WORK_DIR=$(pwd)

./download/download.sh $WORK_DIR Berlin https://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf
./processing/processing.sh $WORK_DIR Berlin