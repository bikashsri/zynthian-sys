#!/bin/bash

cd $ZYNTHIAN_SW_DIR
if [ -d "libsndfile" ]; then
	rm -rf "libsndfile"
fi

git clone -b zynthian https://github.com/riban-bw/libsndfile.git
cd libsndfile

cmake -DBUILD_SHARED_LIBS=RELEASE -DBUILD_SHARED_LIBS=ON -DBUILD_PROGRAMS=OFF -DBUILD_EXAMPLES=OFF -DINSTALL_MANPAGES=OFF -DBUILD_TESTING=OFF .
cmake --build . 
cmake --install .


