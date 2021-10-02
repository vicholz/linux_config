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
  tldr \
  git \
  fortune-mod \
  jq \
  jparse \
  curl \
  wget \
  lynx \
  dos2unix \
  p7zip-full \
  unace \
  ntfs-3g \
  lrzip \
  dnsutils \
  vim \
  screen \
  docker \
  acl \
  ufw \
  wakeonlan

# install fortune
if ! grep -e "/usr/games/fortune" /etc/bash.bashrc 1> /dev/null; then
	echo "/usr/games/fortune" >> /etc/bash.bashrc
fi
