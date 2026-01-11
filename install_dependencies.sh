#!/bin/bash

# for process
sudo apt update -y && sudo apt upgrade -y
sudo apt install osmium-tool -y
sudo apt install osm2pgsql -y

# for frontend 
# Node.js v24.12.0 (npm v11.6.2)