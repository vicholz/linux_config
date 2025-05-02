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
sudo usermod -a -G roms $USER
sudo mkdir -p /storage/roms
sudo chown -R :roms /storage/roms
sudo chmod -R 0775 /storage/roms

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
   force group = roms

END
)

if ! grep -q "\[media\]" /etc/samba/smb.conf; then
	echo "$CFG" | sudo tee -a /etc/samba/smb.conf > /dev/null
fi

sudo systemctl restart smbd
