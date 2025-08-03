#!/usr/bin/env bash

PKGS=wget curl git tmux zoxide neovim vifm zsh ripgrep

if [ "$(id -u)" -eq 0 ]; then
    apt update -y
    DEBIAN_FRONTEND=noninteractive apt install -y ${PKGS}
else
    sudo apt update -y
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ${PKGS}
fi

cd ~
mkdir -p ~/bin
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
mkdir -p ~/.config/vifm
ln -s ~/.dotfiles/.config/vifm/vifmrc ~/.config/vifm/vifmrc
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.zshrc ~/.zshrc

for f in ~/.dotfiles/bin/*; do ln -s $f ~/bin/$(basename $f); done

RUNZSH=yes CHSH=yes KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

