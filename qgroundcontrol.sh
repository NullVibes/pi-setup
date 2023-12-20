#!/bin/bash

sudo apt update
sudo apt install speech-dispatcher libudev-dev libsdl2-dev patchelf build-essential curl -y
cd /opt
sudo wget https://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz
cd qt-*
