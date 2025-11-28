#!/bin/bash

# update
sudo apt update

# install packages
sudo apt -y install \
  7zip \
  acl \
  bash \
  curl \
  ddcutil \
  dnsutils \
  docker-compose \
  docker.io \
  dos2unix \
  flatpak \
  fortune-mod \
  fprintd \
  git \
  golang \
  gparted \
  hcxdumptool \
  hcxkeys \
  hcxtools \
  iat \
  jparse \
  jq \
  libfuse2 \
  libpam-fprintd \
  lrzip \
  lynx \
  network-manager-openvpn \
  ntfs-3g \
  p7zip-full \
  protontricks \
  pv \
  python3 \
  python3-pip \
  python3.13-venv \
  rsync \
  screen \
  transmission \
  ufw \
  unace \
  unzip \
  verse \
  vim \
  vlc \
  wakeonlan \
  wget \
  wifite \
  wine \
  wine64 \
  winetricks \
  xclip \
  xrdp \
  yq \
  yt-dlp \
  zenity \
  zx

echo ""

# install flatpal store
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# create user bashrc.d
mkdir -p $HOME/.bashrc.d

# restrict unprivileged userns to allow chrome based AppImages to run without specifying --no-sandbox
# echo -e "Removing restriction for unpriviledged user namespaces in AppImages..."
# echo -e "kernel.apparmor_restrict_unprivileged_userns=0\n" | sudo tee /etc/sysctl.d/99-unrestrict_unprivileged_userns.conf > /dev/null 

# install default python venv in user home dir
echo -n "Creating default Python venv in '$HOME/.venv'..."
if [ ! -d $HOME/.venv ]; then
  python3 -m venv $HOME/.venv 1> /dev/null
  echo "DONE!"
else
  echo "SKIPPED! Already exists."
fi

# Install Google Chrome repo
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/google-chrome.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
sudo apt update
sudo apt install google-chrome-stable

# add default python venv activator to /etc/bash.bashrc
echo -n "Adding default Python venv activator to '\$HOME/.bashrc.d/python_env.bash'..."
echo "source \$HOME/.venv/bin/activate" > $HOME/.bashrc.d/python_env.bash
echo "DONE!"

# add pbcopy and pbpaste aliases
echo -n "Adding 'pbcopy' and 'pbpaste' aliases to '\$HOME/.bashrc.d/pb_aliases.bash'..."
echo -e "alias pbcopy=\"xclip -selection clipboard\"" > $HOME/.bashrc.d/pb_aliases.bash
echo -e "alias pbpaste=\"xclip -selection clipboard -o\"" >> $HOME/.bashrc.d/pb_aliases.bash
echo "DONE!"

# install verse
echo -n "Adding verse to '\$HOME/.bashrc.d/verse.bash'..."
echo -e "/usr/bin/verse" > $HOME/.bashrc.d/verse.bash
echo "DONE!"

# add $HOME/.bashrc.d/*.bash loader
if ! grep "\$HOME/.bashrc.d" /etc/bash.bashrc > /dev/null; then
CFG=$(cat <<-END

if [ -d \$HOME/.bashrc.d ]; then
        for f in \$(ls \$HOME/.bashrc.d); do
                . \$HOME/.bashrc.d/\$f
        done
fi

END
)
  echo -n "Adding loader for '\$HOME/.bashrc.d/*.bash' files..."
  echo "$CFG" > | sudo tee -a /etc/bash.bashrc > /dev/null
fi

# setup nvidia power management
# if lspci | grep -i "3D controller: NVIDIA" 1> /dev/null; then
#   echo -n "Adding NVIDIA power management config in '/etc/modprobe.d/nvidia-power-management.conf'..."
#   if ! grep "NVreg_PreserveVideoMemoryAllocations=1" /etc/modprobe.d/nvidia-power-management.conf 1> /dev/null; then
#     echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp" >> /etc/modprobe.d/nvidia-power-management.conf
#     echo "DONE!"
#   else
#     echo "SKIPPED! Already exists."
#   fi
# fi

echo -e "DONE!"
echo "Please restart your terminal for changes to take effect."
