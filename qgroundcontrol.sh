#!/bin/bash

sudo apt update
sudo usermod -a -G dialout $USER
sudo apt remove modemmanager -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
sudo apt install libqt5gui5 -y
sudo apt install libfuse2 -y

cd /opt
sudo wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage

#sudo apt install speech-dispatcher libudev-dev libsdl2-dev patchelf build-essential curl qmake gcc -y
#sudo git clone --recursive -j8 https://github.com/mavlink/qgroundcontrol.git
#sudo git submodule update --recursive

sudo chmod +x QGroundControl.AppImage
echo ""
echo "To launch QGroundControl:  ./QGroundControl.AppImage"
