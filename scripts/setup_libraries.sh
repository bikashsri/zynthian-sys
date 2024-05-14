#!/bin/bash

########################################################################
#  Setup Libraries
########################################################################
source "$ZYNTHIAN_SYS_DIR/scripts/zynthian_envars_extended.sh"

LOG_DIR=$(pwd)/log
mkdir -p $LOG_DIR

if [ -d "$LOG_DIR" ]; then
    rm -f $LOG_DIR 2>/dev/null
fi

# Install some extra packages:
apt-get -y install jack-midi-clock midisport-firmware

# Install Pure Data stuff
## REMOVED pd-aubio pd-boids pd-pdp pd-pddp pd-readanysf
## REPLACED pd-import with puredata-import
apt-get -y install puredata puredata-core puredata-utils puredata-import python3-yaml \
pd-lua pd-moonlib pd-pdstring pd-markex pd-iemnet pd-plugin pd-ekext pd-bassemu  \
pd-zexy pd-list-abs pd-flite pd-windowing pd-fftease pd-bsaylor pd-osc pd-sigpack pd-hcs pd-pdogg pd-purepd \
pd-beatpipe pd-freeverb pd-iemlib pd-smlib pd-hid pd-csound  pd-earplug pd-wiimote pd-pmpd pd-motex \
pd-arraysize pd-ggee pd-chaos pd-iemmatrix pd-comport pd-libdir pd-vbap pd-cxc pd-lyonpotpourri pd-iemambi \
pd-mjlib pd-cyclone pd-jmmmp pd-3dp pd-mapping pd-maxlib

# Install ZynAddSubFX
apt-get -y install zynaddsubfx

# Install Linuxsampler
apt-get -y install linuxsampler gigtools

# Install Fluidsynth & SF2 SondFonts
apt-get -y install fluidsynth libfluidsynth-dev fluid-soundfont-gm fluid-soundfont-gs timgm6mb-soundfont
# Create SF2 soft links
ln -s /usr/share/sounds/sf2/*.sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2

#apt-get -y install sfizz

apt-get -y install libclxclient-dev gir1.2-ganv-1.0 libfmt-dev libgirepository1.0-dev
apt-get install -y lvtk-tools
#apt-get -y install aeolus
#apt-get -y install mididings

echo "Creating Python venv ..."
rm -rf $ZYNTHIAN_DIR/venv
if [ -d "$ZYNTHIAN_DIR/venv" ]; then
	source "$ZYNTHIAN_DIR/venv/bin/activate"
else
    mkdir "$ZYNTHIAN_DIR"
    cd "$ZYNTHIAN_DIR"
    python3 -m venv venv --system-site-packages
    python3 -m venv $ZYNTHIAN_DIR
    source "$ZYNTHIAN_DIR/venv/bin/activate"
fi 

pip3 install decorator

mkdir /root/Pd
mkdir /root/Pd/externals

#************************************************
#------------------------------------------------
# Compile / Install Required Libraries
#------------------------------------------------
#************************************************

# Install WiringPi
# Install rubberband
# Install ibsndfile
# Install Jack2
# Install alsaseq Python Library
# Install NTK library
# Install pyliblo library (liblo OSC library for Python)
# Install mod-ttymidi (MOD's ttymidi version with jackd MIDI support)
# Install LV2 lilv library
# Install the LV2 C++ Tool Kit
# Install LV2 Jalv Plugin Host
# Install Aubio Library & Tools
# Install jpmidi (MID player for jack with transport sync)
# Install jack_capture (jackd audio recorder)
# Install jack_smf utils (jackd MID-file player/recorder)
# Install touchosc2midi (TouchOSC Bridge) -- Comment for compile errors
# Install jackclient (jack-client python library)
# Install QMidiNet (MIDI over IP Multicast)
# Install jackrtpmidid (jack RTP-MIDI daemon)
# Install the DX7 SysEx parser
# Install preset2lv2 (Convert native presets to LV2)
# Install QJackCtl
# Install Ganv
# Install Patchage
# Install the njconnect Jack Graph Manager
# Install Mutagen (when available, use pip3 install)
# Install VL53L0X library (Distance Sensor)
# Install MCP4748 library (Analog Output / CV-OUT)
# Install noVNC web viewer
# Install terminal emulator for tornado (webconf)
# Install DT overlays for waveshare displays and others
# Install ZynAddSubFX
# Install Squishbox SF2 soundfonts
# Install Polyphone (SF2 editor)
# Install Sfizz (SFZ player)
# Install Linuxsampler
# Install Fantasia (linuxsampler Java GUI)
# Install setBfree (Hammond B3 Emulator)
# Install Pianoteq Demo (Piano Physical Emulation)
# Install Aeolus (Pipe Organ Emulator)
# Install Mididings (MIDI route & filter)
# Install MOD-HOST
# Install browsepy
# Install MOD-UI
# Install MOD-SDK
# Install Ableton Link Support

# List of Required Libraries
recipes=(
#$ZYNTHIAN_RECIPE_DIR/install_wiringpi.sh
#$ZYNTHIAN_RECIPE_DIR/install_rubberband.sh
#->$ZYNTHIAN_RECIPE_DIR/install_sndfile.sh
#$ZYNTHIAN_RECIPE_DIR/install_jack2.sh
##$ZYNTHIAN_RECIPE_DIR/install_alsaseq.sh
##$ZYNTHIAN_RECIPE_DIR/install_ntk.sh
#$ZYNTHIAN_RECIPE_DIR/install_pyliblo.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-ttymidi.sh
#$ZYNTHIAN_RECIPE_DIR/install_lv2_lilv.sh
#$ZYNTHIAN_RECIPE_DIR/install_lvtk.sh
#$ZYNTHIAN_RECIPE_DIR/install_lv2_jalv.sh
#$ZYNTHIAN_RECIPE_DIR/install_aubio.sh
#$ZYNTHIAN_RECIPE_DIR/install_jpmidi.sh
#$ZYNTHIAN_RECIPE_DIR/install_jack_capture.sh
#$ZYNTHIAN_RECIPE_DIR/install_jack-smf-utils.sh
##$ZYNTHIAN_RECIPE_DIR/install_touchosc2midi.sh
#$ZYNTHIAN_RECIPE_DIR/install_jackclient-python.sh -- need to probably remove it as JACK-client is installed
#$ZYNTHIAN_RECIPE_DIR/install_qmidinet.sh
#$ZYNTHIAN_RECIPE_DIR/install_jackrtpmidid.sh
#$ZYNTHIAN_RECIPE_DIR/install_dxsyx.sh
#$ZYNTHIAN_RECIPE_DIR/install_preset2lv2.sh
#$ZYNTHIAN_RECIPE_DIR/install_qjackctl.sh
#$ZYNTHIAN_RECIPE_DIR/install_ganv.sh
#$ZYNTHIAN_RECIPE_DIR/install_patchage.sh
#$ZYNTHIAN_RECIPE_DIR/install_njconnect.sh
#$ZYNTHIAN_RECIPE_DIR/install_mutagen.sh
#$ZYNTHIAN_RECIPE_DIR/install_VL53L0X.sh
#$ZYNTHIAN_RECIPE_DIR/install_MCP4728.sh
#$ZYNTHIAN_RECIPE_DIR/install_noVNC.sh
#$ZYNTHIAN_RECIPE_DIR/install_terminado.sh
#$ZYNTHIAN_RECIPE_DIR/install_waveshare-dtoverlays.sh
##$ZYNTHIAN_RECIPE_DIR/install_zynaddsubfx.sh
#$ZYNTHIAN_RECIPE_DIR/install_squishbox_sf2.sh
##$ZYNTHIAN_RECIPE_DIR/install_polyphone.sh
#$ZYNTHIAN_RECIPE_DIR/install_sfizz.sh
##$ZYNTHIAN_RECIPE_DIR/install_linuxsampler_stable.sh
#$ZYNTHIAN_RECIPE_DIR/install_fantasia.sh
#$ZYNTHIAN_RECIPE_DIR/install_setbfree.sh
#$ZYNTHIAN_RECIPE_DIR/install_pianoteq_demo.sh
#$ZYNTHIAN_RECIPE_DIR/install_aeolus.sh
#$ZYNTHIAN_RECIPE_DIR/install_mididings.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-host.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-browsepy.sh
#$ZYNTHIAN_RECIPE_DIR/install_mod-ui.sh
##$ZYNTHIAN_RECIPE_DIR/install_mod-sdk.sh
#$ZYNTHIAN_RECIPE_DIR/install_hylia.sh
#$ZYNTHIAN_RECIPE_DIR/install_pd_extra_abl_link.sh
$ZYNTHIAN_RECIPE_DIR/install_distrho_ports.sh
)

for recipe in "${recipes[@]}"
do
    output_file=$LOG_DIR/$(basename $recipe)".out"
    echo "<==== INSTALLING($recipe) ====>"
    $recipe > $output_file 2>&1  
    echo "<==== COMPLETED ($recipe) ====>"
done

## Create SF2 soft links
ln -s /usr/share/sounds/sf2/*.sf2 $ZYNTHIAN_DATA_DIR/soundfonts/sf2

## Setup user config directories
cd $ZYNTHIAN_CONFIG_DIR
mkdir setbfree
ln -s /usr/local/share/setBfree/cfg/default.cfg ./setbfree
cp -a $ZYNTHIAN_DATA_DIR/setbfree/cfg/zynthian_my.cfg ./setbfree/zynthian.cfg
