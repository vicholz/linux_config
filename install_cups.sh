#!/bin/bash

# check if root user | re-run if not
if [ "$(id -u)" != "0" ]; then
	sudo `dirname $0`/`basename $0`
	exit
fi

# update
sudo apt update

# install packages
sudo apt install -y \
    cups \
    cups-ipp-utils \
    printer-driver-gutenprint \
    avahi-daemon
sudo systemctl start cups
sudo systemctl enable cups
sudo ufw allow cups
sed -e -i 's/Order allow,deny/Order allow,deny\n  Allow @LOCAL/g' /tmp/cupsd.conf

# setup avahi
sudo systemctl start avahi-daemon
sudo systemctl enable avahi-daemon
sudo ufw allow 5353/udp
