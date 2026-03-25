#!/bin/bash

shopt -s nullglob

for file in *.xml; do
    mv -- "$file" "${file%.xml}.osm"
done