#!/usr/bin/env bash

# install zsh
sudo apt install -y zsh 
chsh -s $(which zsh)

# oh-my-zsh package install, won't auto switch to the zsh.
sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
