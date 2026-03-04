#!/usr/bin/env bash

# Load the .env file
if [ -f .env ]; then
  set -a
  source .env
  set +a
else
  echo ".env file not found" >&2
  exit 1
fi

# To skip the download, save the "final.osm.pbf" file in the home directory and execute it like this: ./process.sh true
SKIP_DOWNLOAD=$1

# Delete the tmp directory if exists and create an empty one
WORK_DIR=$(pwd)
TMP_DIR=$WORK_DIR/tmp
SAVE_DIR=/home/christian

if [ -d "$TMP_DIR" ]; then
  rm -rf "$TMP_DIR"
fi

mkdir -p "$TMP_DIR"

if [ "$SKIP_DOWNLOAD" == "true" ]; then
  TMP_DIR=$SAVE_DIR
else
  # Download the OSM data
  ./download/download.sh $TMP_DIR || exit 1
fi

# Import the OSM data into the PostgreSQL database
./import/import.sh $WORK_DIR $TMP_DIR

if ! [ "$SKIP_DOWNLOAD" == "true" ]; then 
  # Cleanup the tmp directory
  rm -rf "$TMP_DIR"
fi