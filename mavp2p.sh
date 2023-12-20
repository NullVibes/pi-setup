#!/bin/bash

if [ -f /usr/local/go/bin/go ]; then
  echo 'GO binary found.  Skipping.'
else
  mkdir ~/src && cd ~/src
  wget https://go.dev/dl/go1.21.5.linux-arm64.tar.gz
  sudo tar -C /usr/local -xzf go1.21.5.linux-arm64.tar.gz
  rm go1.21.5.linux-arm64.tar.gz
  echo 'PATH=$PATH:/usr/local/go/bin' | tee -a ~/.profile &>/dev/null
  echo 'GOPATH=$HOME/go' | tee -a ~/.profile &>/dev/null
  source ~/.profile
fi

if [ -f /usr/local/bin/mavp2p ]; then
  echo 'mavp2p binary found.  Skipping.'
else
  cd ~/src
  wget https://github.com/bluenviron/mavp2p/releases/download/v1.2.0/mavp2p_v1.2.0_linux_arm64v8.tar.gz
  sudo tar -C /usr/local/bin -xzf mavp2p_v1.2.0_linux_arm64v8.tar.gz
  rm mavp2p_v1.2.0_linux_arm64v8.tar.gz
fi
