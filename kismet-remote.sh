#!/bin/bash
sudo apt update && sudo apt upgrade -y

# Install Kismet NIGHTLY via Kismet PPA, and RTL-SDR requirements
wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key | sudo apt-key add -
echo 'deb https://www.kismetwireless.net/repos/apt/git/bullseye bullseye main' | sudo tee /etc/apt/sources.list.d/kismet.list
sudo apt update
sudo apt install gpsd gpsd-clients rtl-sdr rtl-433 kismet vim -y

