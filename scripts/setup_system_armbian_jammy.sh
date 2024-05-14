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

#------------------------------------------------
# Update System & Firmware
#------------------------------------------------

# Hold kernel version 
#apt-mark hold raspberrypi-kernel

# Update System
apt-get -y update --allow-releaseinfo-change
apt-get -y dist-upgrade

# Install required dependencies if needed
### REMOVED rpi-update rpi-eeprom
apt-get -y install apt-utils apt-transport-https sudo software-properties-common parted dirmngr gpgv
#htpdate

# Adjust System Date/Time
#htpdate -s www.pool.ntp.org wikipedia.org google.com

# Update Firmware
if [ "$ZYNTHIAN_INCLUDE_RPI_UPDATE" == "yes" ]; then
    rpi-update
fi

#------------------------------------------------
# Add Repositories
#------------------------------------------------

# deb-multimedia repo
#echo "deb http://www.deb-multimedia.org buster main non-free" >> /etc/apt/sources.list
#wget https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb
#dpkg -i deb-multimedia-keyring_2016.8.1_all.deb
#m -f deb-multimedia-keyring_2016.8.1_all.deb
the_ppa='deb https://www.deb-multimedia.org bookworm main non-free'
if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    # commands to add the ppa ...
    add-apt-repository -y "$the_ppa"
    apt-get -y update -oAcquire::AllowInsecureRepositories=true
    apt-get -y --allow-unauthenticated install deb-multimedia-keyring
fi

# KXStudio
#wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
#dpkg -i kxstudio-repos_10.0.3_all.deb
#rm -f kxstudio-repos_10.0.3_all.deb

# KXStudio
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_11.1.0_all.deb
sudo dpkg -i kxstudio-repos_11.1.0_all.deb
rm -f kxstudio-repos_11.1.0_all.deb

# Zynthian
wget -O - https://deb.zynthian.org/deb-zynthian-org.gpg > /etc/apt/trusted.gpg.d/deb-zynthian-org.gpg
echo "deb https://deb.zynthian.org/zynthian-stable buster main" > /etc/apt/sources.list.d/zynthian.list

# Sfizz
### UPDATED to RASPBIAN_11
#sfizz_url_base="http://download.opensuse.org/repositories/home:/sfztools:/sfizz:/develop/Raspbian_11"
#echo "deb $sfizz_url_base/ /" > /etc/apt/sources.list.d/sfizz-dev.list
#curl -fsSL $sfizz_url_base/Release.key | apt-key add -

apt-get -y update
apt-get -y dist-upgrade
apt-get -y autoremove

#------------------------------------------------
# Install Required Packages
#------------------------------------------------

# System
### REMOVED exfat-util
### REPLACED vnc4server with tigervnc-standalone-server
### REPLACED xfwm4-themes with shiki-colors-xfwm-theme
apt-get -y remove --purge isc-dhcp-client triggerhappy logrotate dphys-swapfile
apt-get -y install systemd avahi-daemon dhcpcd-dbus usbutils udisks2 udevil exfatprogs \
xinit xserver-xorg-video-fbdev x11-xserver-utils xinput libgl1-mesa-dri tigervnc-standalone-server \
xfwm4 xfce4-panel xdotool cpufrequtils wpasupplicant wireless-tools iw dnsmasq shiki-colors-xfwm-theme

apt-get -y install firmware-brcm80211 firmware-atheros firmware-realtek atmel-firmware firmware-misc-nonfree
#firmware-ralink

# Alternate XServer with some 2D acceleration
#apt-get -y install xserver-xorg-video-fbturbo
#ln -s /usr/lib/arm-linux-gnueabihf/xorg/modules/drivers/fbturbo_drv.so /usr/lib/xorg/modules/drivers
echo "COMPLETED---> System Packages"

# CLI Tools
### REMOVED  raspi-config mplayer ffmpeg
apt-get -y install psmisc tree joe nano vim p7zip-full i2c-tools ddcutil evtest libts-bin \
fbi scrot mpg123 xloadimage imagemagick fbcat qjackctl mediainfo xterm gpiod xfce4-terminal

echo "COMPLETED---> CLI Tools"

#apt-get install python-smbus (i2c with python)

# Lguyome45: remove for Raspberry pi 4, with this firmware, wifi does not work
# Non-free WIFI firmware for RBPi3
#wget https://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree/firmware-brcm80211_20161130-3+rpt3_all.deb
#dpkg -i firmware-brcm80211_20161130-3+rpt3_all.deb
#rm -f firmware-brcm80211_20161130-3+rpt3_all.deb

#------------------------------------------------
# Development Environment
#------------------------------------------------

#Tools
### ADDED
# QT packages
apt-get -y --no-install-recommends install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools qtdeclarative5-dev libqt5svg5-dev

### REMOVED qt5-default rubberband-cli
apt-get -y --no-install-recommends install build-essential git swig subversion pkg-config autoconf automake premake \
gettext intltool libtool libtool-bin cmake cmake-curses-gui flex bison ngrep gobjc++ \
ruby rake xsltproc vorbis-tools zenity doxygen graphviz glslang-tools


# AV Libraries => WARNING It should be changed on every new debian version!!
#apt-get -y --no-install-recommends install libavcodec58 libavformat58 libavutil56 libavresample4 libavformat-dev \
#libavcodec-dev
apt-get -y --no-install-recommends install libavcodec60 
apt-get -y --no-install-recommends install libavformat60 
apt-get -y --no-install-recommends install libavutil56 
apt-get -y --no-install-recommends install libavresample4 
apt-get -y --no-install-recommends install libavformat-dev 
apt-get -y --no-install-recommends install libavcodec-dev 

echo "COMPLETED---> QT Packages"

# Libraries
### REMOVED laditools liblash-compat-dev 
# AV Libraries => WARNING It should be reviewed on every new debian version!!
### REMOVED libavcodec58 libavformat58 libavutil56 libavresample4 libavformat-dev libavcodec-dev 
### REMOVED librubberband-dev as it has dependency with libfftw3-double3 (>= 3.3.10) but 3.3.8-2ubuntu8 is to be installed
### REPLACED libsndfile-dev to libsndfile1-dev
apt-get -y --no-install-recommends install libx11-dev libx11-xcb-dev libxcb-util-dev libxkbcommon-dev \
libfftw3-dev libmxml-dev zlib1g-dev fluid libfltk1.3-dev libfltk1.3-compat-headers libpango1.0-dev \
libncurses5-dev liblo-dev dssi-dev libjpeg-dev libxpm-dev libcairo2-dev libglu1-mesa-dev \
libasound2-dev dbus-x11 jackd2 libjack-jackd2-dev a2jmidid jack-midi-clock midisport-firmware libffi-dev \
fontconfig-config libfontconfig1-dev libxft-dev libexpat-dev libglib2.0-dev libgettextpo-dev libsqlite3-dev \
libglibmm-2.4-dev libeigen3-dev libsndfile1-dev libsamplerate-dev libarmadillo-dev libreadline-dev \
lv2-c++-tools libxi-dev libgtk2.0-dev libgtkmm-2.4-dev liblrdf-dev libboost-system-dev libzita-convolver-dev \
libzita-resampler-dev fonts-roboto libxcursor-dev libxinerama-dev mesa-common-dev libgl1-mesa-dev \
libfreetype6-dev  libswscale-dev libcanberra-gtk-module '^libxcb.*-dev' \
libcanberra-gtk3-module libxcb-cursor-dev libgtk-3-dev libxcb-util0-dev libxcb-keysyms1-dev libxcb-xkb-dev \
libxkbcommon-x11-dev libssl-dev libmpg123-0 libmp3lame0 libxrender-dev \
libclthreads-dev libclxclient-dev libqt5x11extras5-dev libqt5x11extras5 libqt5svg5-dev libportaudio2

#libjack-dev-session
#non-ntk-dev
#libgd2-xpm-dev
echo "COMPLETED---> System Libraries"

# Python
### REPLACE python3-pyqt4 to python3-pyqt5
apt-get -y install python3 python3-dev cython3 python3-cffi python3-tk python3-dbus python3-mpmath python3-pil python3-venv \
python3-pil.imagetk python3-setuptools python3-pyqt5 python3-numpy-dev python3-evdev python3-soundfile python3-usb \
python3-soundfile pyliblo-utils

if [ "$ZYNTHIAN_INCLUDE_PIP" == "yes" ]; then
    apt-get -y install python3-pip
fi

pip3 install --upgrade pip

echo "Creating Python venv ..."
if [ -d "$ZYNTHIAN_DIR/venv" ]; then
	source "$ZYNTHIAN_DIR/venv/bin/activate"
else
    mkdir "$ZYNTHIAN_DIR"
    cd "$ZYNTHIAN_DIR"
    python3 -m venv venv --system-site-packages
    python3 -m venv $ZYNTHIAN_DIR
    source "$ZYNTHIAN_DIR/venv/bin/activate"
fi 

### ADDED type-extensions
pip3 install type-extensions typing_extensions

pip3 install tornado tornadostreamform websocket-client
pip3 install jsonpickle oyaml JACK-Client psutil pexpect requests meson ninja tornado_xstatic terminado xstatic XStatic_term.js
pip3 install alsa-midi abletonparsing pyrubberband sox ffmpeg-python
pip3 install adafruit-circuitpython-neopixel-spi mido mutagen python-rtmidi

echo "COMPLETED---> Python Dependencies"

### ADDED
# Dependency for Zyncoder
apt-get -y install libjack-dev libncurses-dev libasound2-dev libasound2 libasound2-data libgpiod-dev autotools-dev

#apt-get -y install libboost-all-dev
#apt-get -y install lua5.3 liblua5.3-dev

# DEPENDENCY for libsndfile 
# Needed for SFC_SET_LOOP_INFO
apt-get -y install libmpg123-dev libmp3lame-dev libopus-dev libflac-dev libogg-dev

echo "COMPLETED---> Additional Dependencies"
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

# Zynthian System Scripts and Config files
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_SYS_BRANCH}" "${ZYNTHIAN_SYS_REPO}"

# Zyncoder library
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_ZYNCODER_BRANCH}" "${ZYNTHIAN_ZYNCODER_REPO}"
./zyncoder/build.sh

echo "COMPLETED---> Zyncoder Library"

# Install rubberband
$ZYNTHIAN_RECIPE_DIR/install_rubberband.sh
echo "COMPLETED---> rubberband"

# Install ibsndfile
$ZYNTHIAN_RECIPE_DIR/install_sndfile.sh
echo "COMPLETED---> libsndfile"

# Zynthian UI
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_UI_BRANCH}" "${ZYNTHIAN_UI_REPO}"
cd $ZYNTHIAN_UI_DIR
sed -i 's/add_definitions(-Werror/add_definitions(-Werror -Wno-format -Wno-format-extra-args/' $ZYNTHIAN_UI_DIR/zynlibs/zynaudioplayer/CMakeLists.txt
sed -i 's/add_definitions(-Werror/add_definitions(-Werror -Wno-format -Wno-format-extra-args/' $ZYNTHIAN_UI_DIR/zynlibs/zynmixer/CMakeLists.txt

find ./zynlibs -type f -name build.sh -exec {} \;

echo "COMPLETED---> Zynthian UI"

# Zynthian Data
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_DATA_BRANCH}" "${ZYNTHIAN_DATA_REPO}"

# Zynthian Webconf Tool
cd $ZYNTHIAN_DIR
git clone -b "${ZYNTHIAN_WEBCONF_BRANCH}" "${ZYNTHIAN_WEBCONF_REPO}"

# Create needed directories
#mkdir "$ZYNTHIAN_DATA_DIR/soundfonts"
#mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/lv2"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/banks"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/zynaddsubfx/presets"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/mod-ui/pedalboards"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/puredata"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/puredata/generative"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/puredata/synths"
mkdir "$ZYNTHIAN_MY_DATA_DIR/presets/sysex"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sf2"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/sfz"
mkdir "$ZYNTHIAN_MY_DATA_DIR/soundfonts/gig"
mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots"
mkdir "$ZYNTHIAN_MY_DATA_DIR/snapshots/000"
mkdir "$ZYNTHIAN_MY_DATA_DIR/capture"
mkdir "$ZYNTHIAN_MY_DATA_DIR/preset-favorites"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/patterns"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/tracks"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/sequences"
mkdir "$ZYNTHIAN_MY_DATA_DIR/zynseq/scenes"
mkdir "$ZYNTHIAN_PLUGINS_DIR"
mkdir "$ZYNTHIAN_PLUGINS_DIR/lv2"

# Copy default snapshots
cp -a $ZYNTHIAN_DATA_DIR/snapshots/* $ZYNTHIAN_MY_DATA_DIR/snapshots/000

echo "COMPLETED---> Zynthian Data Setup"
#************************************************
#------------------------------------------------
# System Adjustments
#------------------------------------------------
#************************************************

#Change Hostname
if [ "$ZYNTHIAN_CHANGE_HOSTNAME" == "yes" ]; then
    echo "zynthian" > /etc/hostname
    sed -i -e "s/127\.0\.1\.1.*$/127.0.1.1\tzynthian/" /etc/hosts
fi

# Run configuration script
$ZYNTHIAN_SYS_DIR/scripts/update_zynthian_data.sh

# Configure Systemd Services
$ZYNTHIAN_SYS_DIR/scripts/configure_systemd_services.sh

# Setup loading of Zynthian Environment variables ...
echo "source $ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh" >> /root/.bashrc
# Shell & Login Config
echo "source $ZYNTHIAN_SYS_DIR/etc/profile.zynthian" >> /root/.profile

# On first boot, resize SD partition, regenerate keys, etc.
$ZYNTHIAN_SYS_DIR/scripts/set_first_boot.sh

echo "COMPLETED---> Zynthian System Adjustments"
#************************************************
#------------------------------------------------
# Compile / Install Required Libraries
#------------------------------------------------
#************************************************
cd $ZYNTHIAN_SYS_DIR/scripts
./setup_libraries.sh
echo "COMPLETED---> Install Libraries"

#------------------------------------------------
# Install Plugins
#------------------------------------------------
cd $ZYNTHIAN_SYS_DIR/scripts
./setup_plugins_rbpi.sh
echo "COMPLETED---> Install Plugins"
#------------------------------------------------
# Install Ableton Link Support
#------------------------------------------------
$ZYNTHIAN_RECIPE_DIR/install_hylia.sh
$ZYNTHIAN_RECIPE_DIR/install_pd_extra_abl_link.sh

echo "COMPLETED---> Ableton Link Support"
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

echo "COMPLETED---> Config scripts"
#************************************************
#------------------------------------------------
# End & Clean
#------------------------------------------------
#************************************************

# UNCOMMNET
#Block MS repo from being installed
#apt-mark hold raspberrypi-sys-mods
#touch /etc/apt/trusted.gpg.d/microsoft.gpg

# Clean
apt-get -y autoremove # Remove unneeded packages
if [[ "$ZYNTHIAN_SETUP_APT_CLEAN" == "yes" ]]; then # Clean apt cache (if instructed via zynthian_envars.sh)
    apt-get clean
fi

echo "COMPLETED---> Setup"