#!/bin/sh

osm2pgsql  \
--host localhost \
--database osm \
--user osm_user \
--password \
--output=flex \
--style=street_segments.lua \
--slim \
--prefix bern \
bern.osm.pbf