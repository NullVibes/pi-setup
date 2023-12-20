#!/bin/bash

sudo apt update
sudo apt install speech-dispatcher libudev-dev libsdl2-dev patchelf build-essential curl qmake gcc -y
cd /opt
sudo git clone --recursive -j8 https://github.com/mavlink/qgroundcontrol.git
sudo git submodule update --recursive
cd qgroundcontrol

