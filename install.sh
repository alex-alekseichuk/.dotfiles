#!/usr/bin/env bash

packages=(wget curl git tmux zoxide neovim vifm zsh ripgrep)

if [ "$(id -u)" -eq 0 ]; then
  apt_cmd="DEBIAN_FRONTEND=noninteractive apt"
else
  apt_cmd="sudo DEBIAN_FRONTEND=noninteractive apt"
fi

$apt_cmd update -y
$apt_cmd install -y "${packages[@]}"

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

