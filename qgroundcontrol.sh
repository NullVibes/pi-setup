#!/bin/bash
#
# QGroundControl pre-built binaries for linux are x86_64 images, and will not work on the RPi.
# Everythng has to be built from source.
#
sudo apt update
sudo usermod -a -G dialout $USER
sudo apt remove modemmanager -y
sudo apt install speech-dispatcher libudev-dev libsdl2-dev patchelf build-essential curl gcc qtcreator openjdk-11-jdk-headless -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl libqt5gui5 libfuse2 -y

cd /opt
sudo git clone --recursive -j8 https://github.com/mavlink/qgroundcontrol.git
cd qgroundcontrol
sudo git submodule update --recursive
echo -e "DEFINES += DISABLE_AIRMAP\r\n" | tee user_config.pri
mkdir build
cd build
qmake ../
make -j3

echo ""
echo "To launch QGroundControl:  ./staging/QGroundControl"
