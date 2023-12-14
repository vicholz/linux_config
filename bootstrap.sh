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
  7zip \
  acl \
  curl \
  dnsutils \
  docker \
  docker-compose \
  dos2unix \
  fortune-mod \
  git \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-gsconnect \
  gnome-shell-extension-gsconnect-browsers \
  gnome-shell-extension-manager \
  gnome-shell-extension-ubuntu-dock \
  gnome-shell-extensions \
  gnome-shell-ubuntu-extensions \
  gnome-tweaks \
  gnome-weather \
  golang \
  gparted \
  hcxdumptool \
  hcxkeys \
  hcxtools \
  jparse \
  jq \
  lrzip \
  lynx \
  ntfs-3g \
  p7zip-full \
  protontricks \
  python3 \
  python3-pip \
  screen \
  tldr \
  transmission \
  ufw \
  unace \
  vim \
  vlc \
  wakeonlan \
  wget \
  wifite \
  wine \
  wine64 \
  winetricks \
  yt-dlp \
  yq \
  zx \

# install fortune
if ! grep -e "/usr/games/fortune" /etc/bash.bashrc 1> /dev/null; then
	echo "/usr/games/fortune" >> /etc/bash.bashrc
fi
