#!/bin/bash

sudo apt upgrade -y
sudo apt install -y \
	python3 \
	python3-dev \
	python3-venv \
	python3-pip \
	libffi-dev \
	libssl-dev \
	libjpeg-dev \
	zlib1g-dev \
	autoconf \
	build-essential \
	libtiff5 \
	software-properties-common \
	apparmor-utils \
	apt-transport-https \
	avahi-daemon \
	ca-certificates \
	curl \
	dbus \
	jq \
	network-manager \
	network-manager-gnome \
	socat

sudo curl -sL "https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh" | bash -s -- -m raspberrypi4-64
