#!/bin/bash

# check if root user | re-run if not
if [ "$(id -u)" != "0" ]; then
	sudo `dirname $0`/`basename $0`
	exit
fi

# update
apt update

# upgrade existing
apt upgrade -y

# install packages
apt -y install \
  bat \
  tldr \
  openjdk-11-jdk \
  ant \
  maven \
  python3 \
  xml2 \
  xml-twig-tools \
  xmlstarlet \
  jparse \
  i2c-tools \
  samba \
  smbclient \
  vsftpd \
  build-essential \
  bin86 \
  automake \
  scons \
  pkg-config \
  git \
  fortune-mod \
  jq \
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
  minidlna \
  cups \
  rng-tools

# install fortune
if ! grep -e "/usr/games/fortune" /etc/bash.bashrc 1> /dev/null; then
	echo "/usr/games/fortune" >> /etc/bash.bashrc
fi
