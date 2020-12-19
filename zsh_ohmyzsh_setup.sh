#!/usr/bin/env bash

# install zsh
sudo apt install zsh -y
chsh -s $(which zsh)

# oh-my-zsh package install
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
