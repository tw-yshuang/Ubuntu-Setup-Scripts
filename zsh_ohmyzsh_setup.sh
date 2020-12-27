#!/usr/bin/env bash

# install zsh
sudo apt install zsh -y
chsh -s $(which zsh)

# oh-my-zsh package install
sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
