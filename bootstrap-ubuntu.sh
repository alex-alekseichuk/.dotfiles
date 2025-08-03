#!/usr/bin/env bash
cd ~
sudo apt update -y
sudo apt install -y git
git clone https://github.com/alex-alekseichuk/.dotfiles.git
chmod a+x ~/.dotfiles/install.sh
~/.dotfiles/install.sh

