#!/usr/bin/env bash

function Echo_Color(){
    case $1 in
        r* | R* )
        COLOR='\e[31m'
        ;;
        g* | G* )
        COLOR='\e[32m'
        ;;
        y* | Y* )
        COLOR='\e[33m'
        ;;
        b* | B* )
        COLOR='\e[34m'
        ;;
        *)
        echo "$COLOR Wrong COLOR keyword!\e[0m" 
        ;;
    esac
    echo -e "$COLOR$2\e[0m"
}


all_accept = -y

if [[ $SHELL != *zsh ]]; then
  chmod +x package.sh zsh_ohmyzsh_setup.sh ohmyzsh_config.sh terminal_config.sh application.sh pyenv_setup.sh nvm_setup.sh
  ./package.sh $all_accept
  ./zsh_ohmyzsh_setup.sh
  ./ohmyzsh_config.sh $all_accept
  Echo_Color g "Completed ZSH setup"
  Echo_Color y "relogin and execute this script again!!"
else
  ./terminal_config.sh $all_accept
  ./application.sh $all_accept
  ./pyenv_setup.sh $all_accept
  ./nvm_setup.sh $all_accept
  Echo_Color g "All Done~~~"
fi
