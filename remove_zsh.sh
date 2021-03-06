#!/usr/bin/env bash

# remove command
sudo apt remove zsh -y
sudo apt autoremove
sudo rm -rf /home/$USER/.oh-my-zsh
sudo rm -rf ~/*.*zsh*
sudo rm -rf /themes/powerlevel10k
sudo rm -rf /plugins/zsh-autosuggestions
sudo rm -rf /plugins/zsh-syntax-highlighting