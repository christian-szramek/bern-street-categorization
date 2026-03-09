#!/bin/bash

# for process
sudo apt update -y && sudo apt upgrade -y
sudo apt install osmium-tool -y
sudo apt install osm2pgsql -y

# for frontend 
sudo apt install curl -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
nvm use 25
source ~/.bashrc