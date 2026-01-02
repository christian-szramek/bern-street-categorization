#!/bin/bash

WORK_DIR=$1
CITY_NAME=$2
REGION_URL=$3
BOUNDARIES_URL=$4

echo $WORK_DIR
echo $CITY_NAME
echo $REGION_URL
echo $BOUNDARIES_URL


# OSM region file
echo "Downloading the OSM region file..." 
if [ -f "$WORK_DIR/import/region.osm.pbf" ]; then
    rm "$WORK_DIR/import/region.osm.pbf"
fi
curl -L -o "$WORK_DIR/import/region.osm.pbf" $REGION_URL

# OSM boundaries file
if [ "$BOUNDARIES_URL" = "" ]; then
    mv "$WORK_DIR/import/region.osm.pbf" "$WORK_DIR/$CITY_NAME.osm.pbf"
    exit 0;
fi

echo "Downloading the OSM boundaries file..."
if [ -f "$WORK_DIR/import/boundaries.osm.pbf" ]; then
    rm "$WORK_DIR/import/boundaries.osm.pbf"
fi
curl -L -o "$WORK_DIR/import/boundaries.osm" $BOUNDARIES_URL

# Crop

echo "Cropping the OSM region file..."
if [ -f "$WORK_DIR/${CITY_NAME}.osm.pbf" ]; then 
    rm "$WORK_DIR/${CITY_NAME}.osm.pbf"
fi
osmium extract -p "$WORK_DIR/import/boundaries.osm" "$WORK_DIR/import/region.osm.pbf" -o "$WORK_DIR/${CITY_NAME}.osm.pbf"

rm "$WORK_DIR/import/boundaries.osm"
rm "$WORK_DIR/import/region.osm.pbf"
