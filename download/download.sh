#!/bin/bash

TMP_DIR=$1

# Dowmload the OSM region file
echo "Downloading the OSM region file..." 

curl -L -o "$TMP_DIR/region.osm.pbf" $REGION_URL

# Download the OSM boundaries file
# If no boundaries file is required -> move and rename the region.osm.pbf and exit
if [ "$BOUNDARIES_URL" = "" ]; then
    mv "$TMP_DIR/region.osm.pbf" "$TMP_DIR/final.osm.pbf"
    exit 0;
fi

echo "Downloading the OSM boundaries file..."

curl -L -o "$TMP_DIR/boundaries.osm" $BOUNDARIES_URL

# Crop the region file with the boundaries file
echo "Cropping the OSM region file..."

osmium extract -p "$TMP_DIR/boundaries.osm" "$TMP_DIR/region.osm.pbf" -o "$TMP_DIR/final.osm.pbf"
