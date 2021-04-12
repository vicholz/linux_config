
#!/bin/bash

# check if root user | re-run if not
if [ "$(id -u)" != "0" ]; then
	sudo `dirname $0`/`basename $0`
	exit
fi

# add jenkins.io key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

# add jenkins.io repo to sources
if ! grep -q "deb https://pkg.jenkins.io/debian binary/" /etc/apt/sources.list; then
  echo "deb https://pkg.jenkins.io/debian binary/" >> /etc/apt/sources.list
fi

# update
sudo apt update

# install packages
sudo apt install -y \
  openjdk-11-jdk \
  jenkins
