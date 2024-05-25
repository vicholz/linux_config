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

addgroup roms || true
useradd roms
addgroup $USER roms
echo "roms:roms" | chpasswd
echo -e "roms\roms\n" | smbpasswd -a roms
mkdir -p /storage/roms
chown -R roms:roms /storage/roms
chmod -R 0755 /storage/roms

CFG=$(cat <<-END

[roms]
   comment = ROMS
   browseable = yes
   path = /storage/roms
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
