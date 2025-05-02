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
    inotify-tools

# create tools dir
mkdir -p /opt/tools

# install nginx config monitor script
wget https://raw.githubusercontent.com/vicholz/rpi4_config/master/tools/nginx_config_monitor.sh -O /opt/tools/nginx_config_monitor.sh
chmod a+x /opt/tools/nginx_config_monitor.sh

# add nginx_config_monitor.service
wget https://raw.githubusercontent.com/vicholz/rpi4_config/master/lib/systemd/system/nginx_config_monitor.service -O /lib/systemd/system/nginx_config_monitor.service

# restart services
systemctl daemon-reload
systemctl enable nginx_config_monitor
systemctl start nginx_config_monitor
