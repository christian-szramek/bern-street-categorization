#!/bin/bash

source "utils.sh"

load_env_variables

# Delete the tmp directory if exists and create an empty one
WORK_DIR=$(pwd)
TMP_DIR=$WORK_DIR/tmp

if [ -d "$TMP_DIR" ]; then
  rm -rf "$TMP_DIR"
fi

mkdir -p "$TMP_DIR"

# Download the OSM data
./download/download.sh $TMP_DIR || exit 1


# Import the OSM data into the PostgreSQL database
./import/import.sh $WORK_DIR $TMP_DIR || exit 1

# Cleanup the tmp directory
rm -rf "$TMP_DIR"