#!/bin/bash

# check if root user | re-run if not
if [ "$(id -u)" != "0" ]; then
	sudo `dirname $0`/`basename $0`
	exit
fi

# add jenkins.io key
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg

# add jenkins.io repo to sources
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# update
sudo apt update

# install packages
sudo apt install -y \
  openjdk-11-jdk \
  mailutils \
  jenkins

# install plugins
sudo -u jenkins mkdir -p /var/lib/jenkins/plugins
sudo -u jenkins wget https://updates.jenkins.io/download/plugins/thinBackup/latest/thinBackup.hpi -O /var/lib/jenkins/plugins/thinBackup.hpi

# allow jenkins to use shadow
usermod -a -G shadow jenkins
setfacl -m u:jenkins:r /etc/shadow

# restart after changes
systemctl restart jenkins
