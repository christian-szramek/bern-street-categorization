#!/bin/bash

./reset.sh || exit 1
./process.sh || exit 1

# restart the backend services
docker restart pg_tileserv
docker restart pg_featureserv