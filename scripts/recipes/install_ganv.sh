#!/bin/bash

ZYNTHIAN_SW_DIR=/home/bikash/Development/temp

cd $ZYNTHIAN_SW_DIR
if [ -d "ganv" ]; then
	rm -rf "ganv"
fi
git clone https://github.com/drobilla/ganv.git
cd ganv
meson setup build
cd build
meson compile
sudo meson install
#meson clean
cd ..
rm -rf build
cd ..

