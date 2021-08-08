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
  openjdk-11-jdk \
  ant \
  maven \
  python3 \
  xml2 \
  xml-twig-tools \
  xmlstarlet \
  i2c-tools \
  build-essential \
  bin86 \
  automake \
  scons \
  pkg-config \
  git \
  rng-tools
