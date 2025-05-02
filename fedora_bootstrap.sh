#!/bin/bash

# install packages
sudo dnf -y install \
  acl \
  bash \
  curl \
  ddcutil \
  dnsutils \
  docker-cli \
  docker-compose \
  docker-distribution \
  dos2unix \
  flatpak \
  fortune-mod \
  git \
  golang \
  gparted \
  hcxtools \
  jq \
  lynx \
  ntfs-3g \
  protontricks \
  pv \
  python3 \
  python3-pip \
  rsync \
  screen \
  tldr \
  transmission \
  ufw \
  unzip \
  vim \
  vlc \
  wget \
  wine \
  wine64 \
  winetricks \
  xclip \
  xrdp \
  yq \
  yt-dlp \
  zenity

echo ""

# create user bashrc.d
mkdir -p $HOME/.bashrc.d

# restrict unprivileged userns to allow chrome based AppImages to run without specifying --no-sandbox
echo -e "Removing restriction for unpriviledged user namespaces in AppImages..."
echo -e "kernel.apparmor_restrict_unprivileged_userns=0\n" | sudo tee /etc/sysctl.d/99-unrestrict_unprivileged_userns.conf > /dev/null 

# install default python venv in user home dir
echo -n "Creating default Python venv in '$HOME/.venv'..."
if [ ! -d $HOME/.venv ]; then
  python3 -m venv $HOME/.venv 1> /dev/null
  echo "DONE!"
else
  echo "SKIPPED! Already exists."
fi

# add default python venv activator to /etc/bash.bashrc
echo -n "Adding default Python venv activator to '\$HOME/.bashrc.d/python_env.bash'..."
echo "source \$HOME/.venv/bin/activate" > $HOME/.bashrc.d/python_env.bash
echo "DONE!"

# add pbcopy and pbpaste aliases
echo -n "Adding 'pbcopy' and 'pbpaste' aliases to '\$HOME/.bashrc.d/pb_aliases.bash'..."
echo -e "alias pbcopy=\"xclip -selection clipboard\"" > $HOME/.bashrc.d/pb_aliases.bash
echo -e "alias pbpaste=\"xclip -selection clipboard -o\"" >> $HOME/.bashrc.d/pb_aliases.bash
echo "DONE!"

# install fortune
echo -n "Adding fortune to '\$HOME/.bashrc.d/fortune.bash'..."
echo -e "/usr/bin/fortune" > $HOME/.bashrc.d/fortune.bash
echo "DONE!"

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

echo -e "\nDONE!\n"
echo "Please restart your terminal for changes to take effect."
