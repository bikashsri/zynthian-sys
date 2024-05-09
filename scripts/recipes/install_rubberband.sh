#!/bin/bash:

ZYNTHIAN_SW_DIR=/home/bikash/Development/temp

cd $ZYNTHIAN_SW_DIR
if [ -d "rubberband" ]; then
	rm -rf "rubberband"
fi
git clone https://github.com/breakfastquay/rubberband.git
cd rubberband
meson setup --buildtype release build
ninja -C build
ninja -C build install


