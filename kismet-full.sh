#!/bin/bash

DISTID=$(lsb_release -a | grep "Distributor ID" | awk '{print $3}')
CODENAME=$(lsb_release -a | grep "Codename" | awk '{print $2}')

echo "This installer will build the -NIGHTLY- (most up-to-date) package from Git." 
read -p "Continue? (Y/n): " -n1 CONT

if [[ $CONT == "n" ]]; then
  exit
fi


wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key --quiet | gpg --dearmor | sudo tee /usr/share/keyrings/kismet-archive-keyring.gpg >/dev/null

if [[ $DISTID == "Ubuntu" ]]; then
  if [[ $CODENAME == "focal" ]]; then
    echo 'deb [signed-by=/usr/share/keyrings/kismet-archive-keyring.gpg] https://www.kismetwireless.net/repos/apt/git/focal focal main' | sudo tee /etc/apt/sources.list.d/kismet.list >/dev/null
  elif [[ $CODENAME == "jammy" ]]; then
    echo 'deb [signed-by=/usr/share/keyrings/kismet-archive-keyring.gpg] https://www.kismetwireless.net/repos/apt/git/jammy jammy main' | sudo tee /etc/apt/sources.list.d/kismet.list >/dev/null
  fi
  sudo apt install linux-headers-generic -y
elif [[ $DISTID == "Raspbian" ]]; then
  if [[ $CODENAME == "bullseye" ]]; then
    echo 'deb [signed-by=/usr/share/keyrings/kismet-archive-keyring.gpg] https://www.kismetwireless.net/repos/apt/git/bullseye bullseye main' | sudo tee /etc/apt/sources.list.d/kismet.list >/dev/null
  elif [[ $CODENAME == "bookworm" ]]; then
    echo 'deb [signed-by=/usr/share/keyrings/kismet-archive-keyring.gpg] https://www.kismetwireless.net/repos/apt/git/bookworm bookworm main' | sudo tee /etc/apt/sources.list.d/kismet.list >/dev/null
  fi
  sudo apt install raspberrypi-kernel-headers -y
fi

sudo apt update
sudo apt install build-essential vim dkms bluez gpsd gpsd-clients kismet tcpdump rtl-sdr rtl-433 -y
sudo usermod -aG kismet $(whoami)
sudo cp kis-src.sh /etc/kismet
sudo chmod +x /etc/kismet/kis-src.sh
sudo cp kismet.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable kismet.service

cd /opt
git clone -b v5.6.4.2 https://github.com/aircrack-ng/rtl8812au.git
cd rtl*

if [[ $DISTID == "Raspbian" ]]; then
  sudo sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
  sudo sed -i 's/CONFIG_PLATFORM_ARM64_RPI = n/CONFIG_PLATFORM_ARM64_RPI = y/g' Makefile
fi
sudo make dkms_install
