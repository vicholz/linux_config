#!/bin/bash

# check if root user | re-run if not
if [ "$(id -u)" != "0" ]; then
	sudo !!
	exit
fi

# update
sudo apt update

# install packages
sudo apt install -y \
	docker \
	docker-compose \
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

curl -sL "https://raw.githubusercontent.com/vicholz/supervised-installer/master/installer.sh" -o ha_installer.sh && sudo bash ha_installer.sh -m raspberrypi4-32
