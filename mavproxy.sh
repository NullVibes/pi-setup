#!/bin/bash

sudo apt install python3-dev python3-opencv python3-pip python3-matplotlib python3-lxml python3-pygame

# Optional packages; not needed if running headless.
# sudo apt install python3-wxgtk4.0

pip3 install PyYAML mavproxy --user
echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc

# Prevent "permission denied" errors for serial connections.
sudo usermod -aG dialout $(`whoami`)
