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
    python3

# install python packages
pip3 install pyserial

# create tools dir
mkdir -p /opt/tools

# install fan control script
wget https://raw.githubusercontent.com/vicholz/woltool/master/woltool.py -O /opt/tools/woltool.py
chmod a+x /opt/tools/woltool.py

# install service
wget https://raw.githubusercontent.com/vicholz/rpi4_config/master/lib/systemd/system/woltool.service -O /lib/systemd/system/woltool.service
systemctl daemon-reload
systemctl enable woltool.service
