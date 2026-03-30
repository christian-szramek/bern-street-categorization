#!/bin/bash

source "utils.sh"

load_env_variables
check_test_env_variable_exist

# Delete the tmp directory if exists and create an empty one
WORK_DIR=$(pwd)
TMP_DIR=$WORK_DIR/tmp


# if test final.osm.pbf's should be processed
if [ "$TEST" = "true" ]; then
  echo "Processing the test data"
  
  export CITY="BERN"
  export RESTRICTION="CH"
  ./import/import.sh $WORK_DIR $WORK_DIR/import/flex/test/test_data/bern

  export CITY="BERLIN"
  export RESTRICTION="DE"
  ./import/import.sh $WORK_DIR $WORK_DIR/import/flex/test/test_data/berlin
  exit 0
fi

rm -rf "$TMP_DIR"

IFS=','

for city in $CITIES; do
  city_name=$(echo "$city" \
           | tr '[:upper:]' '[:lower:]' \
           | tr '_' ' ' \
           | sed -E 's/(^| )([a-z])/\1\u\2/g')

  echo "Processing ${city_name}..."

  mkdir $TMP_DIR

  city_restriction_variable="${city}_RESTRICTION"
  city_region_url_variable="${city}_REGION_URL"
  city_boundaries_url_variable="${city}_BOUNDARIES_URL"

  export CITY=${city}
  export RESTRICTION="${!city_restriction_variable}"
  export REGION_URL="${!city_region_url_variable}"
  export BOUNDARIES_URL="${!city_boundaries_url_variable}"

  # Download the OSM data
  ./download/download.sh $TMP_DIR || exit 1

  # Import the OSM data into the PostgreSQL database
  ./import/import.sh $WORK_DIR $TMP_DIR || exit 1

  rm -rf "$TMP_DIR"
done