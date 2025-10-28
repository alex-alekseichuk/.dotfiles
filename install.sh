#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

packages=(wget curl git tmux zoxide neovim vifm zsh ripgrep)

if [ "$(id -u)" -eq 0 ]; then
  apt_cmd=" apt"
else
  apt_cmd="sudo apt"
fi

$apt_cmd update -y
$apt_cmd install -y "${packages[@]}"

cd ~
mkdir -p ~/bin

ln -s ~/.dotfiles/.vimrc ~/.vimrc

mkdir -p ~/.config/nvim
mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
ln -s ~/.dotfiles/.config/nvim/init.lua ~/.config/nvim/init.lua

mkdir -p ~/.config/vifm
ln -s ~/.dotfiles/.config/vifm/vifmrc ~/.config/vifm/vifmrc

ln -s ~/.dotfiles/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

for f in ~/.dotfiles/bin/*; do ln -s $f ~/bin/$(basename $f); done

RUNZSH=yes CHSH=yes KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

