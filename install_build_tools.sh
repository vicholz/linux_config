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
  build-essential \
  bin86 \
  automake \
  scons \
  pkg-config \
  git \
  rng-tools
