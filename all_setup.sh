#!/usr/bin/env bash

chmod +x package.sh zsh_ohmyzsh_setup.sh terminal-theme_and_ohmyzsh-config.sh application.sh pyenv_setup.sh
./package.sh -y
./zsh_ohmyzsh_setup.sh
./terminal-theme_and_ohmyzsh-config.sh -y
./application.sh -y
./pyenv_setup.sh -y
