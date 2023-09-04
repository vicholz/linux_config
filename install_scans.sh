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
    samba \
    samba-client 

addgroup storage || true
useradd scans
addgroup scans storage
echo "scans:scans" | chpasswd
echo -e "scans\nscans\n" | smbpasswd -a scans
mkdir -p /storage/scans
chown scans:scans /storage/scans
chmod -R 0700 /storage/scans

CFG=$(cat <<-END
[scans]
   comment = Scans
   browseable = yes
   path = /storage/scans
   guest ok = no
   read only = no
   create mask = 2770
   directory mask = 2770
   force directory mode = 2770
   force group = scans

END
)

if ! grep -q "\[scans\]" /etc/samba/smb.conf; then
	echo "$CFG" >> /etc/samba/smb.conf
fi
