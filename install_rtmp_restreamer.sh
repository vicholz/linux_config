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
    ffmpeg \
    nginx \
    libnginx-mod-stream \
    libnginx-mod-rtmp \
    stunnel4
    sudo systemctl enable nginx.service # make sure nginx is enabled
    sudo systemctl enable stunnel4.service # make sure stunnel4 is enabled
    systemctl enable systemd-networkd-wait-online.service # makes sure we have an IP before starting network dependant services

# add nginxadmin group with permissions to restart
addgroup nginxadmin
echo "%nginxadmin ALL=NOPASSWD: /bin/systemctl * nginx" >> /etc/sudoers

# update nginx.service to wait for internet connection before starting
wget https://raw.githubusercontent.com/vicholz/rtmp_restreamer/master/lib/systemd/system/nginx.service -O /lib/systemd/system/nginx.service

# add rtmp config to nginx
wget https://raw.githubusercontent.com/vicholz/rtmp_restreamer/master/usr/share/nginx/modules-available/rtmp-restreamer.conf -O /usr/share/nginx/modules-available/rtmp-restreamer.conf.tmpl
cp /usr/share/nginx/modules-available/rtmp-restreamer.conf.tmpl /usr/share/nginx/modules-available/rtmp-restreamer.conf
ln -s /usr/share/nginx/modules-available/rtmp-restreamer.conf /etc/nginx/modules-enabled/50-rtmp-restreamer.conf

# add stunnel4 configs
wget https://raw.githubusercontent.com/vicholz/rtmp_restreamer/master/etc/default/stunnel4 -O /etc/default/stunnel4
wget https://raw.githubusercontent.com/vicholz/rtmp_restreamer/master/etc/stunnel/stunnel.conf -O /etc/stunnel/stunnel.conf
mkdir -p /etc/stunnel/conf.d
wget https://raw.githubusercontent.com/vicholz/rtmp_restreamer/master/etc/stunnel/conf.d/facebook-tunnel.conf -O /etc/stunnel/conf.d/facebook-tunnel.conf

# restart services
systemctl daemon-reload
systemctl restart stunnel4; systemctl status stunnel4
systemctl restart nginx; systemctl status nginx
