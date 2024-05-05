#!/bin/bash

# mididings

cd $ZYNTHIAN_SW_DIR

if [ -d "mididings" ]; then
	rm -rf "mididings"
fi

git clone https://github.com/dsacre/mididings.git
cd mididings
./setup.py build 
./setup.py install
cd ..
