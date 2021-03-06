#!/usr/bin/env bash

chmod +x package.sh zsh_ohmyzsh_setup.sh ohmyzsh_config.sh terminal_config.sh application.sh pyenv_setup.sh nvm_setup.sh
./package.sh -y
./zsh_ohmyzsh_setup.sh
./ohmyzsh_config.sh -y
./terminal_config.sh -y
./application.sh -y
./pyenv_setup.sh -y
./nvm_setup.sh -y
