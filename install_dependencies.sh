#!/bin/bash

# for process
sudo apt update -y && sudo apt upgrade -y
sudo apt install osmium-tool -y
sudo apt install osm2pgsql -y

# for process testing
sudo apt install lua5.3
sudo apt install liblua5.3-dev
sudo apt install luarocks
sudo apt install libexpat1-dev
luarocks install luaexpat
# Add eval "$(luarocks path)" to .bashrc and source it

# for frontend 
sudo apt install curl -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
nvm use 25
source ~/.bashrc