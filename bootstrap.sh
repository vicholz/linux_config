#!/bin/bash

# update
sudo apt update

# install packages
sudo apt -y install \
  7zip \
  acl \
  curl \
  dnsutils \
  docker.io \
  docker-compose \
  dos2unix \
  fortune-mod \
  git \
  gnome-shell-extension-alphabetical-grid \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-desktop-icons-ng \
  gnome-shell-extension-gpaste \
  gnome-shell-extension-gsconnect \
  gnome-shell-extension-gsconnect-browsers \
  gnome-shell-extension-manager \
  gnome-shell-extension-prefs \
  gnome-shell-extension-ubuntu-dock \
  gnome-shell-extension-ubuntu-tiling-assistant \
  gnome-shell-extensions \
  gnome-shell-ubuntu-extensions \
  gnome-tweaks \
  gnome-weather \
  golang \
  gparted \
  hcxdumptool \
  hcxkeys \
  hcxtools \
  jparse \
  jq \
  lrzip \
  lynx \
  ntfs-3g \
  p7zip-full \
  protontricks \
  python3 \
  python3-pip \
  screen \
  tldr \
  transmission \
  ufw \
  unace \
  vim \
  vlc \
  wakeonlan \
  wget \
  wifite \
  wine \
  wine64 \
  winetricks \
  yt-dlp \
  yq \
  zx \

echo ""

# install default python venv in user home dir
echo -n "Creating default Python venv in '$HOME/.venv'..."
if [ ! -d $HOME/.venv ]; then
  python3 -m venv $HOME/.venv 1> /dev/null
  echo "DONE!"
else
  echo "SKIPPED! Already exists."
fi

# add default python venv activator to /etc/bash.bashrc
echo -n "Adding default Python venv activator to '/etc/bash.bashrc'..."
if ! grep -e "source $HOME/.venv/bin/activate" /etc/bash.bashrc 1> /dev/null; then
	echo -e "\nif [ -d \$HOME/.venv ] && [ -f \$HOME/.venv/bin/activate ]; then\n\tsource \$HOME/.venv/bin/activate\nfi\n" | sudo tee -a /etc/bash.bashrc > /dev/null
  echo "DONE!"
else
  echo "SKIPPED! Already exists."
fi

# add user bin path to /etc/bash.bashrc
echo -n "Adding \$HOME/bin export to PATH in '/etc/bash.bashrc'..."
if ! grep -e "export PATH=\$HOME/bin:\$PATH" /etc/bash.bashrc 1> /dev/null; then
	echo -e "\nif [ -d \$HOME/bin ]; then\n\texport PATH=\$HOME/bin:\$PATH\nfi\n" | sudo tee -a /etc/bash.bashrc > /dev/null
  echo "DONE!"
else
  echo "SKIPPED! Already exists."
fi

# install fortune
echo -n "Adding fortune to '/etc/bash.bashrc'..."
if ! grep -e "/usr/games/fortune" /etc/bash.bashrc 1> /dev/null; then
  echo -e "\n/usr/games/fortune\n" | sudo tee -a /etc/bash.bashrc > /dev/null
  echo "DONE!"
else
  echo "SKIPPED! Already exists."
fi

# setup nvidia power management
if lspci | grep -i "3D controller: NVIDIA" 1> /dev/null; then
  echo -n "Adding NVIDIA power management config in '/etc/modprobe.d/nvidia-power-management.conf'..."
  if ! grep "NVreg_PreserveVideoMemoryAllocations=1" /etc/modprobe.d/nvidia-power-management.conf 1> /dev/null; then
    echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp" >> /etc/modprobe.d/nvidia-power-management.conf
    echo "DONE!"
  else
    echo "SKIPPED! Already exists."
  fi
fi
