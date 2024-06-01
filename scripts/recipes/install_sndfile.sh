#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d "libsndfile" ]; then
	rm -rf "libsndfile"
fi

git clone -b zynthian https://github.com/riban-bw/libsndfile.git
cd libsndfile
cmake .
make & make install


