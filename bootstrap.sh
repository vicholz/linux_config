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
  gnome-tweaks \
  python3 \
  python3-pip \
  yt-dlp \
  golang \
  wifite \
  hcxdumptool \
  hcxkeys \
  hcxtools \
  git
