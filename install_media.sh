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

addgroup storage || true
useradd media
addgroup media storage
echo "media:media" | chpasswd
echo -e "media\nmedia\n" | smbpasswd -a media
mkdir -p /storage/media
chown -R media:media /storage/media
chmod -R 0755 /storage/media

CFG=$(cat <<-END

[media]
   comment = Media
   browseable = yes
   path = /storage/media
   guest ok = no
   read only = no
   create mask = 0755
   directory mask = 0755

END
)

if ! grep -q "\[media\]" /etc/samba/smb.conf; then
	echo -e $CFG >> /etc/samba/smb.conf
fi
