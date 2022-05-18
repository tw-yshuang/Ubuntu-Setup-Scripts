#!/usr/bin/env bash

function Echo_Color(){
  case $1 in
    r* | R* )
    COLOR='\033[0;31m'
    ;;
    g* | G* )
    COLOR='\033[0;32m'
    ;;
    y* | Y* )
    COLOR='\033[0;33m'
    ;;
    b* | B* )
    COLOR='\033[0;34m'
    ;;
    *)
    echo "$COLOR Wrong COLOR keyword!\033[0m" 
    ;;
    esac
    echo -e "$COLOR$2\033[0m"
  }



all_accept=-y

if [[ $SHELL != *zsh ]]; then
  chmod +x package.sh zsh_ohmyzsh_setup.sh ohmyzsh_config.sh
  ./package.sh $all_accept
  ./zsh_ohmyzsh_setup.sh
  ./ohmyzsh_config.sh $all_accept
  Echo_Color g "Completed ZSH setup"
  Echo_Color y "relogin and execute this script again!!"
else
  chmod +x terminal_config.sh application.sh language_package.sh custom_function.sh 
  ./terminal_config.sh $all_accept
  ./application.sh $all_accept
  ./language_package.sh $all_accept
  ./custom_function.sh $all_accept
  Echo_Color g "All Done~~~"
fi
