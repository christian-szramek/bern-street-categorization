#!/bin/bash

# for process
sudo apt update -y && sudo apt upgrade -y
sudo apt install osmium-tool -y
sudo apt install osm2pgsql -y

# for process testing
sudo apt install lua5.3 -y
sudo apt install liblua5.3-dev -y
sudo apt install luarocks -y
sudo apt install libexpat1-dev -y
luarocks install luaexpat -y
# Add eval "$(luarocks path)" to .bashrc and source it

# for frontend 
sudo apt install curl -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
nvm use 25
source ~/.bashrc

# for Python Jupyter Notebook
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y