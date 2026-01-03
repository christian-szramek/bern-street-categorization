#!/usr/bin/env bash

# Load .env file
if [ -f .env ]; then
  set -a
  source .env
  set +a
else
  echo ".env file not found" >&2
  exit 1
fi

WORK_DIR=$(pwd)

./download/download.sh $WORK_DIR
./import/import.sh $WORK_DIR