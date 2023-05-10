#!/bin/bash

# Waveshare DT overlays (DTBs)

cd $ZYNTHIAN_SW_DIR
if [ -d "waveshare-dtoverlays" ]; then
	rm -rf "waveshare-dtoverlays"
fi

git clone https://github.com/swkim01/waveshare-dtoverlays
#git clone https://github.com/waveshare/LCD-show.git waveshare-dtoverlays
cd waveshare-dtoverlays
rm -f /boot/overlays/waveshare*
cp -a *.dtbo /boot/overlays
#for file in *.dtb; do
#  cp -a "$file" "/boot/overlays/${file%.dtb}.dtbo"
#done
