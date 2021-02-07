#!/bin/bash

cd $ZYNTHIAN_SW_DIR

if [ -d "MCP4728" ]; then
	rm -rf "MCP4728"
fi

git clone https://github.com/marko-pi/MCP4728
cd "MCP4728"
make
make install
ldconfig

#rm -rf "MCP4728"