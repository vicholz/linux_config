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
    samba

addgroup nginx || true
useradd nginx -g nginx
addgroup nginx nginx
echo "nginx:nginx" | chpasswd
echo -e "nginx\nginx\n" | smbpasswd -a nginx

# update facl for nginx user
setfacl -R -m u:nginx:rw /etc/nginx

# create samba config
CFG=$(cat <<-END

[nginx]
   comment = nginx config
   browseable = yes
   path = /etc/nginx
   guest ok = no
   read only = no
   create mask = 0755
   directory mask = 0755

END
)

# add samba config
if ! grep -q "\[nginx\]" /etc/samba/smb.conf; then
	echo $CFG >> /etc/samba/smb.conf
fi

# restart samba
systemctl restart smbd
