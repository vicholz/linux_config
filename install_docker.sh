#!/bin/bash

# check if root user | re-run if not
if [ "$(id -u)" != "0" ]; then
	sudo !!
	exit
fi

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
