#!/bin/bash

mkdir ~/src && cd ~/src
wget https://go.dev/dl/go1.21.5.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-arm64.tar.gz
rm go1.21.5.linux-arm64.tar.gz

echo 'PATH=$PATH:/usr/local/go/bin' | tee -a ~/.profile &>/dev/null
echo 'GOPATH=$HOME/go' | tee -a ~/.profile &>/dev/null
source ~/.profile
