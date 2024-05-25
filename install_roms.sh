#!/bin/bash

# update
sudo apt update

# upgrade existing
sudo apt upgrade -y

# install packages
sudo apt -y install \
    samba \
    samba-client \

sudo addgroup roms || true
sudo useradd roms
sudo addgroup $USER roms
sudo echo "roms:roms" | chpasswd
sudo echo -e "roms\roms\n" | smbpasswd -a roms
sudo mkdir -p /storage/roms
sudo chown -R roms:roms /storage/roms
sudo chmod -R 0755 /storage/roms

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
	sudo echo "$CFG" >> /etc/samba/smb.conf
fi
