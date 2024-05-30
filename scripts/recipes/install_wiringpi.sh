#!/bin/bash

# Uninstall official wiringpi deb package
apt-get -y remove wiringpi

cd $ZYNTHIAN_SW_DIR
if [ -d "./WiringPi" ]; then
	rm -rf "./WiringPi"
fi

if [[ $rbpi_version =~ "OrangePi" ]]; then
	git clone https://github.com/orangepi-xunlong/wiringOP WiringPi
	cd WiringPi
	./build
	cd ..
else
	# Remove previous sources
	# Download, build and install WiringPi library
	#git clone https://github.com/WiringPi/WiringPi.git
	git clone https://github.com/zynthian/WiringPi.git
	cd WiringPi
	./build
	cd ..
end if