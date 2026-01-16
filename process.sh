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

# Delete the tmp directory if exists and create an empty one
WORK_DIR=$(pwd)
TMP_DIR=$WORK_DIR/tmp

if [ -d "$TMP_DIR" ]; then
  rm -rf "$TMP_DIR"
fi

mkdir -p "$TMP_DIR"

# Download the OSM data
./download/download.sh $TMP_DIR

# Import the OSM data into the PostgreSQL database
./import/import.sh $WORK_DIR $TMP_DIR

# Cleanup the tmp directory
rm -rf "$TMP_DIR"