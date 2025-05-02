#!/bin/bash

# check if root user | re-run if not
if [ "$(id -u)" != "0" ]; then
	sudo `dirname $0`/`basename $0`
	exit
fi

# update
apt update

# install packages
apt -y install \
  curl \
  wget

# add steam big picture xsession
wget https://raw.githubusercontent.com/vicholz/linux_config/main/usr/share/xsessions/steam.desktop -O /usr/share/xsessions/steam.desktop
wget https://raw.githubusercontent.com/vicholz/linux_config/main/usr/lib/steam/icon.png -O /usr/lib/steam/icon.png
