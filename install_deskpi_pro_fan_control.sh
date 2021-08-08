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
    python3

# install python packages
pip3 install pyserial

# create tools dir
mkdir -p /opt/tools

# install fan control script
wget https://raw.githubusercontent.com/vicholz/rpi4_config/master/tools/deskpi_pro_fan_control.py -O /opt/tools/deskpi_pro_fan_control.py 
chmod a+x /opt/tools/deskpi_pro_fan_control.py 

# install service
wget https://raw.githubusercontent.com/vicholz/rpi4_config/master/lib/systemd/system/deskpi_pro_fan_control.service -O /lib/systemd/system/deskpi_pro_fan_control.service
systemctl daemon-reload
systemctl enable deskpi_pro_fan_control.service
