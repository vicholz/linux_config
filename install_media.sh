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
usermod -a media -G storage
echo "media:media" | chpasswd
echo -e "media\nmedia\n" | smbpasswd -a media
mkdir -p /storage/media
chown -R media:media /storage/media
chmod -R 2755 /storage/media

# update minidlna.conf
cp /etc/minidlna.conf /etc/minidlna.conf.orig
sed -i "s/media_dir=.*/media_dir=\/storage\/media/" /etc/minidlna.conf

CFG=$(cat <<-END

[media]
   comment = Media
   browseable = yes
   path = /storage/media
   guest ok = yes
   read only = no
   create mask = 2775
   directory mask = 2775
   force directory mode = 2775
   force group = media

END
)

if ! grep -q "\[media\]" /etc/samba/smb.conf; then
	echo "$CFG" >> /etc/samba/smb.conf
fi
