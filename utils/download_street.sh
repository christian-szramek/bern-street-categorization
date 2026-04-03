#!/bin/bash

ID=$1

curl -o "$ID.osm" "https://api.openstreetmap.org/api/0.6/way/$ID/full"
