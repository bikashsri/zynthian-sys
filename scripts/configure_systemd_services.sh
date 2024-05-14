#!/bin/bash
#******************************************************************************
# ZYNTHIAN PROJECT: Delayed action flags library
# 
# + Manage flags for restarting services and rebooting zynthian
# 
# Copyright (C) 2015-2021 Fernando Moyano <jofemodo@zynthian.org>
#
#******************************************************************************

# Separated Configure Systemd Services
systemctl daemon-reload
systemctl enable dhcpcd
systemctl enable avahi-daemon
#systemctl enable devmon@root
#systemctl disable raspi-config
systemctl disable cron
systemctl disable rsyslog
systemctl disable ntp
#systemctl disable htpdate
systemctl disable wpa_supplicant
systemctl disable hostapd
systemctl disable dnsmasq
systemctl disable unattended-upgrades
systemctl disable apt-daily.timer
systemctl enable backlight
systemctl enable cpu-performance
systemctl enable splash-screen
systemctl enable wifi-setup
systemctl enable jack2
systemctl enable mod-ttymidi
systemctl enable a2jmidid
systemctl enable zynthian
systemctl enable zynthian-webconf
systemctl enable zynthian-config-on-boot