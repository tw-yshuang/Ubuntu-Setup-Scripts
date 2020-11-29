#!/bin/bash
echo "installing zsh"
sudo apt install zsh
chsh -s $(which zsh)
echo "Done!! please restart your terminal~"