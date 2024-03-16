
aptpkgs=""

# -----------------------------------------------------------------------------
# Load current patchlevel
# -----------------------------------------------------------------------------

if [ -f "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt" ]; then
	current_patchlevel=$(cat "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt")
else
	current_patchlevel="20240220.1"
	echo "$current_patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
fi

echo "CURRENT PATCH LEVEL: $current_patchlevel"

# -----------------------------------------------------------------------------
# Temporal patches to development image until final ORAM release
# -----------------------------------------------------------------------------

patchlevel="20240221.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	echo "set enable-bracketed-paste off" > /root/.inputrc
	$ZYNTHIAN_RECIPE_DIR/install_dexed_lv2.sh
	$ZYNTHIAN_RECIPE_DIR/install_fluidsynth.sh
fi

patchlevel="20240221.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	wget -O - https://deb.zynthian.org/deb-zynthian-org.gpg > "/etc/apt/trusted.gpg.d/deb-zynthian-org.gpg"
	echo "deb https://deb.zynthian.org/zynthian-testing bookworm main" > "/etc/apt/sources.list.d/zynthian.list"
	#echo "deb https://deb.zynthian.org/zynthian-stable bookworm main" > "/etc/apt/sources.list.d/zynthian.list"
	apt -y remove libsndfile1-dev
	aptpkgs="$aptpkgs libsdl2-dev libibus-1.0-dev gir1.2-ibus-1.0 libdecor-0-dev libflac-dev libgbm-dev \
	libibus-1.0-5 libmpg123-dev libvorbis-dev libogg-dev libopus-dev libpulse-dev libpulse-mainloop-glib0 \
	libsndio-dev libsystemd-dev libudev-dev libxss-dev libxt-dev libxv-dev libxxf86vm-dev"
fi

patchlevel="20240222.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	apt -y remove x42-plugins
	apt -y install fonts-freefont-ttf libglu-dev libftgl-dev
	$ZYNTHIAN_RECIPE_DIR/install_x42_plugins.sh
fi

patchlevel="20240222.2"
# Dropped!

patchlevel="20240222.3"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	echo "deb https://deb.zynthian.org/zynthian-testing bookworm main" > "/etc/apt/sources.list.d/zynthian.list"
	res=`dpkg -s libsndfile1-dev 2>&1 | grep "Status:"`
	if [ "$res" == "Status: install ok installed" ]; then
		apt -y remove libsndfile1-dev
	fi
	res=`dpkg -s libsndfile1-zyndev 2>&1 | grep "Status:"`
	if [ "$res" == "Status: install ok installed" ]; then
		apt -y remove libsndfile1-zyndev
	fi
	aptpkgs="$aptpkgs libsndfile-zyndev"
fi

patchlevel="20240222.4"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	echo "opensynth" | vncpasswd -f > /root/.vnc/passwd
	chmod go-r /root/.vnc/passwd
	aptpkgs="$aptpkgs x11vnc"
fi

patchlevel="20240225.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	systemctl disable glamor-test.service
	rm -f /usr/share/X11/xorg.conf.d/20-noglamor.conf
fi

patchlevel="20240227.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	pip3 install xstatic XStatic_term.js
fi

patchlevel="20240228.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	aptpkgs="$aptpkgs xserver-xorg-input-evdev"
fi

patchlevel="20240305.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	aptpkgs="$aptpkgs xfce4-terminal"
fi

patchlevel="20240308.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	apt-get -y remove zynaddsubfx zynaddsubfx-data
	apt-get -y install -t bookworm zynaddsubfx
	apt-mark hold zynaddsubfx
fi

patchlevel="20240308.2"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	rm -rf $ZYNTHIAN_SW_DIR/browsepy
	$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
fi

patchlevel="20240313.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	aptpkgs="$aptpkgs sooperlooper"
fi

patchlevel="20240316.1"
if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "APPLYING PATCH $patchlevel ..."
	echo "deb https://github.com/jamulussoftware/jamulus/releases/latest/download/ ./" > /etc/apt/sources.list.d/jamulus.list
	aptpkgs="$aptpkgs jamulus"
fi

# 2024-01-08: Install alsa-midi (chain_manager)
#if is_python_module_installed.py alsa-midi; then
#	pip3 install alsa-midi
#fi

# -----------------------------------------------------------------------------
# End of patches section
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Install selected debian packages
# -----------------------------------------------------------------------------

# Unhold some packages
#apt-mark unhold raspberrypi-kernel
#apt-mark unhold raspberrypi-sys-mods

# Install needed apt packages
if [ "$aptpkgs" ]; then
	apt -y update --allow-releaseinfo-change
	apt -y install $aptpkgs
fi

# -----------------------------------------------------------------------------
# Save current patch level
# -----------------------------------------------------------------------------

if [[ "$current_patchlevel" < "$patchlevel" ]]; then
	echo "$patchlevel" > "$ZYNTHIAN_CONFIG_DIR/patchlevel.txt"
else
	echo "NO NEW PATCHES TO APPLY."
fi


# -----------------------------------------------------------------------------
# Upgrade System
# -----------------------------------------------------------------------------

if [[ ! "$ZYNTHIAN_SYS_BRANCH" =~ ^stable.* ]] || [[ "$ZYNTHIAN_FORCE_UPGRADE" == "yes" ]]; then
	echo "UPGRADING DEBIAN PACKAGES ..."
	if [ -z "$aptpkgs" ]; then
		apt -y update --allow-releaseinfo-change
	fi
	#dpkg --configure -a # => Recover from broken upgrade
	apt -y upgrade
fi

# -----------------------------------------------------------------------------
# Clean apt packages
# -----------------------------------------------------------------------------

apt -y autoremove
apt -y autoclean

# -----------------------------------------------------------------------------
# Bizarre stuff that shouldn't be needed but sometimes is
# -----------------------------------------------------------------------------

# Reinstall firmware to latest stable version
#apt install --reinstall raspberrypi-bootloader raspberrypi-kernel

# Update firmware to a recent version that works OK!!
#if [[ "$VIRTUALIZATION" == "none" ]] && [[ "$LINUX_KERNEL_VERSION" < "5.15.61-v7l+" ]]; then
	#echo "LINUX KERNEL VERSION: $LINUX_KERNEL_VERSION"
	#SKIP_WARNING=1 rpi-update
	#set_reboot_flag
#fi

# Install a firmware version that works OK!!
#if [[ "$LINUX_KERNEL_VERSION" != "5.10.49-v7l+" ]]; then
#	rpi-update -y dc6dc9bc6692d808fcce5ace9d6209d33d5afbac
#	set_reboot_flag
#fi

