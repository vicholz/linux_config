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
    git \
    p7zip-full \
    python3-pip \
    python3-wxgtk4.0 \
    grub2-common \
    grub-pc-bin \
    parted \
    dosfstools \
    ntfs-3g

# install WoeUSB-ng
sudo pip3 install WoeUSB-ng
