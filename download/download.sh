#!/bin/bash

TMP_DIR=$1

# Dowmload the OSM region file
echo "Downloading the OSM region file..." 

if ! curl -fL --retry 3 --retry-delay 5 -o "$TMP_DIR/region.osm.pbf" $REGION_URL; then
    echo "Failed to download the OSM region file from: $REGION_URL. Please try again."
    exit 1;
fi

# Download the OSM boundaries file
# If no boundaries file is required -> move and rename the region.osm.pbf and exit
if [ "$BOUNDARIES_URL" = "" ]; then
    mv "$TMP_DIR/region.osm.pbf" "$TMP_DIR/final.osm.pbf"
    exit 0;
fi

echo "Downloading the OSM boundaries file..."

if ! curl -fL --retry 3 --retry-delay 5 -o "$TMP_DIR/boundaries.osm" $BOUNDARIES_URL; then
    echo "Failed to download the OSM boundaries file from: $BOUNDARIES_URL. Please try again."
    exit 1;
fi

# Crop the region file with the boundaries file
echo "Cropping the OSM region file..."

osmium extract -p "$TMP_DIR/boundaries.osm" "$TMP_DIR/region.osm.pbf" -o "$TMP_DIR/final.osm.pbf"
