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
    samba \
    samba-client \
    minidlna \
    avahi-daemon

useradd media
echo "media:media" | chpasswd
echo -e "media\nmedia\n" | smbpasswd -a media

CFG=$(cat <<-END

[scans]
   comment = Scans
   browseable = yes
   path = /storage/scans
   guest ok = no
   read only = no
   create mask = 0775
   directory mask = 0775

END
)

if ! grep -q "\[scans\]" smb.conf; then
	echo $CFG >> /etc/samba/smb.conf
fi
