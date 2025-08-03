# dotfiles

Bootstar under root in docker container:

```bash
cd ~
apt update -y
apt install -y git
git clone https://github.com/alex-alekseichuk/.dotfiles.git
chmod a+x ~/.dotfiles/install.sh
~/.dotfiles/install.sh
```

Bootstrap in regular non-root ubuntu environment:

```bash
cd ~
sudo apt update -y
sudo apt install -y git
git clone https://github.com/alex-alekseichuk/.dotfiles.git
chmod a+x ~/.dotfiles/install.sh
~/.dotfiles/install.sh
```

(Note or remember these line)

It installs CLI tools and their configuration.

