#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Zynthian Setup Script
# 
# Setup a Zynthian Box in a fresh raspbian-lite "buster" image
# 
# Copyright (C) 2015-2019 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# For a full copy of the GNU General Public License see the LICENSE.txt file.
# 
#******************************************************************************

#------------------------------------------------------------------------------
# Load Environment Variables
#------------------------------------------------------------------------------

source "zynthian_envars_extended.sh"

#------------------------------------------------
# Set default config
#------------------------------------------------

[ -n "$ZYNTHIAN_INCLUDE_RPI_UPDATE" ] || ZYNTHIAN_INCLUDE_RPI_UPDATE=no
[ -n "$ZYNTHIAN_INCLUDE_PIP" ] || ZYNTHIAN_INCLUDE_PIP=yes
[ -n "$ZYNTHIAN_CHANGE_HOSTNAME" ] || ZYNTHIAN_CHANGE_HOSTNAME=yes
#[ -n "$ZYNTHIAN_SYS_REPO" ] || ZYNTHIAN_SYS_REPO="https://github.com/zynthian/zynthian-sys.git"
[ -n "$ZYNTHIAN_SYS_REPO" ] || ZYNTHIAN_SYS_REPO="https://github.com/bikashsri/zynthian-sys.git"
[ -n "$ZYNTHIAN_UI_REPO" ] || ZYNTHIAN_UI_REPO="https://github.com/zynthian/zynthian-ui.git"
[ -n "$ZYNTHIAN_ZYNCODER_REPO" ] || ZYNTHIAN_ZYNCODER_REPO="https://github.com/zynthian/zyncoder.git"
[ -n "$ZYNTHIAN_WEBCONF_REPO" ] || ZYNTHIAN_WEBCONF_REPO="https://github.com/zynthian/zynthian-webconf.git"
[ -n "$ZYNTHIAN_DATA_REPO" ] || ZYNTHIAN_DATA_REPO="https://github.com/zynthian/zynthian-data.git"
[ -n "$ZYNTHIAN_SYS_BRANCH" ] || ZYNTHIAN_SYS_BRANCH="oram"
[ -n "$ZYNTHIAN_UI_BRANCH" ] || ZYNTHIAN_UI_BRANCH="oram"
[ -n "$ZYNTHIAN_ZYNCODER_BRANCH" ] || ZYNTHIAN_ZYNCODER_BRANCH="oram"
[ -n "$ZYNTHIAN_WEBCONF_BRANCH" ] || ZYNTHIAN_WEBCONF_BRANCH="oram"
[ -n "$ZYNTHIAN_DATA_BRANCH" ] || ZYNTHIAN_DATA_BRANCH="oram"


echo "Creating Python venv ..."
if [ -d "$ZYNTHIAN_DIR/venv" ]; then
	source "$ZYNTHIAN_DIR/venv/bin/activate"
else
    cd "$ZYNTHIAN_DIR"
    python3 -m venv venv --system-site-packages
    python3 -m venv $ZYNTHIAN_DIR
    source "$ZYNTHIAN_DIR/venv/bin/activate"
fi 

### ADDED type-extensions
#pip3 install type-extensions typing_extensions

#pip3 install tornado tornadostreamform websocket-client
#pip3 install jsonpickle oyaml JACK-Client psutil pexpect requests meson ninja tornado_xstatic terminado xstatic XStatic_term.js
#pip3 install alsa-midi abletonparsing pyrubberband sox ffmpeg-python
#pip3 install adafruit-circuitpython-neopixel-spi
#pip3 install mido mutagen python-rtmidi

echo "COMPLETED---> Python Dependencies"


#************************************************
#------------------------------------------------
# Create Zynthian Directory Tree & 
# Install Zynthian Software from repositories
#------------------------------------------------
#************************************************

# Create needed directories
mkdir "$ZYNTHIAN_DIR"
mkdir "$ZYNTHIAN_CONFIG_DIR"
mkdir "$ZYNTHIAN_SW_DIR"

# Zynthian UI
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_UI_BRANCH}" "${ZYNTHIAN_UI_REPO}"
#sed -i '/Global variables/a #define SFC_SET_LOOP_INFO 0x10E1' $ZYNTHIAN_UI_DIR/zynlibs/zynaudioplayer/player.cpp
#sed -i 's/add_definitions(-Werror/add_definitions(-Werror -Wno-format -Wno-format-extra-args/' $ZYNTHIAN_UI_DIR/zynlibs/zynaudioplayer/CMakeLists.txt
#sed -i 's/add_definitions(-Werror/add_definitions(-Werror -Wno-format -Wno-format-extra-args/' $ZYNTHIAN_UI_DIR/zynlibs/zynmixer/CMakeLists.txt

cd $ZYNTHIAN_UI_DIR
if [ -d "zynlibs" ]; then
	find ./zynlibs -type f -name build.sh -exec {} \;
else
	if [ -d "jackpeak" ]; then
		./jackpeak/build.sh
	fi
	if [ -d "zynseq" ]; then
		./zynseq/build.sh
	fi
fi

echo "COMPLETED---> Zynthian UI"

# Install touchosc2midi (TouchOSC Bridge)
### FIX  commented for compile errors
#$ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh

#echo "COMPLETED---> touchosc2midi"
# Install Mididings (MIDI route & filter)
#apt-get -y install mididings
#pip3 install decorator
#$ZYNTHIAN_RECIPE_DIR/install_mididings.sh

#echo "COMPLETED---> Mididings"

#Install MOD-UI
#$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh

#echo "COMPLETED---> MOD-UI"

#------------------------------------------------
# Install Plugins
#------------------------------------------------
#cd $ZYNTHIAN_SYS_DIR/scripts
#./setup_plugins_rbpi.sh

#echo "COMPLETED---> Install Plugins"
#------------------------------------------------
# Install Ableton Link Support
#------------------------------------------------
#$ZYNTHIAN_RECIPE_DIR/install_hylia.sh

#echo "COMPLETED---> hylia"
#$ZYNTHIAN_RECIPE_DIR/install_pd_extra_abl_link.sh

#echo "COMPLETED---> Ableton Link Support"

exit 1
#************************************************
#------------------------------------------------
# Final Configuration
#------------------------------------------------
#************************************************

# Create flags to avoid running unneeded recipes.update when updating zynthian software
if [ ! -d "$ZYNTHIAN_CONFIG_DIR/updates" ]; then
	mkdir "$ZYNTHIAN_CONFIG_DIR/updates"
fi

# Run configuration script before ending
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_sys.sh

e:cho "COMPLETED---> Config scripts"
#************************************************
#------------------------------------------------
# End & Clean
#------------------------------------------------
#************************************************

#Block MS repo from being installed
apt-mark hold raspberrypi-sys-mods
touch /etc/apt/trusted.gpg.d/microsoft.gpg

# Clean
apt-get -y autoremove # Remove unneeded packages
if [[ "$ZYNTHIAN_SETUP_APT_CLEAN" == "yes" ]]; then # Clean apt cache (if instructed via zynthian_envars.sh)
    apt-get clean
fi

echo "COMPLETED---> Setup"