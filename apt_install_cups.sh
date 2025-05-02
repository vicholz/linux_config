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
    ufw \
    cups \
    cups-ipp-utils \
    printer-driver-gutenprint \
    printer-driver-brlaser \
    avahi-daemon
sudo systemctl start cups
sudo systemctl enable cups
sudo ufw allow cups
#sed -i 's/Order allow,deny/Order allow,deny\n  Allow @LOCAL/g' /tmp/cupsd.conf

# setup avahi
sudo systemctl start avahi-daemon
sudo systemctl enable avahi-daemon
sudo ufw allow 5353/udp

# install rollo driver
wget https://www.rollo.com/driver-dl/beta/rollo-driver-raspberrypi-beta.zip -O /tmp/rollo.zip
unzip /tmp/rollo.zip -d /tmp/rollo
chmod a+x /tmp/rollo/install.run
/tmp/rollo/install.run

sudo usermod -a -G lpadmin pi
sudo cupsctl --remote-admin --remote-any --share-printers

sudo systemctl restart cups
