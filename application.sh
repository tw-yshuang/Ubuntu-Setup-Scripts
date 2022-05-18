#!/usr/bin/env bash
#>            +------------------+
#>            |  application.sh  |
#>            +------------------+
#-
#- SYNOPSIS
#-
#-    ./application.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./application.sh -y

#====================================================
# Part 1. Option Tool
#====================================================
# Print script help
function show_script_help(){
    echo
    head -17 $0 | # find this file top 16 lines.
    grep "^#[-|>]" | # show the line that include "#-" or "#>".
    sed -e "s/^#[-|>]*//1" # use nothing to replace "#-" or "#>" that the first keyword in every line.  
    echo 
}
# Receive arguments in slient mode.
all_accept=0
if [ "$#" -gt 0 ]; then
    while [ "$#" -gt 0 ]; do
        case "$1" in
            # Help
            "-h"|"--help")
                show_script_help
                exit 1
            ;;
            # All Accept
            "-y")
                all_accept=1
                shift 1
            ;;
        esac
    done
fi

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

function Ask_yn(){
    printf "\033[0;33m$1\033[0m\033[0;33m [y/n] \033[0m"
    if [ $all_accept = 1 ]; then
        echo '-y'
        return 1
    fi
    read respond
    if [ "$respond" = "y" -o "$respond" = "Y" -o "$respond" = "" ]; then
        return 1
    elif [ "$respond" = "n" -o "$respond" = "N" ]; then
        return 0
    else
        Echo_Color r 'wrong command!!'
        Ask_yn $1
        return $?
    fi
    unset respond
}

#====================================================
# Part 2. Main
#====================================================
sudo apt-get update
sudo apt-get upgrade

declare -A Application_dict
Application_dict=([code]="VScode" [google-chrome]="Chrome" [vlc]="vlc" [gimp]="GIMP" [kolourpaint]="kolourpaint4" [obs]="obs-studio" )

for key in ${!Application_dict[*]}; do
    app_root="$(command -v $key)" # get application root
    if [ "$app_root" = "" ]; then
        Ask_yn "Do you want to install ${Application_dict[$key]}?"; result=$? # get Ask_yn() return {Application_dict[$key]}
        if [ $result = 1 ]; then
            case ${Application_dict[$key]} in 
                "VScode" ) # install VScode
                    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
                    rm -f packages.microsoft.gpg
                    sudo apt install apt-transport-https -y
                    sudo apt update
                    sudo apt install code -y
                    ;;
                "Chrome" ) # install Chrome
                    wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                    sudo dpkg -i ./google-chrome-stable_current_amd64.deb
                    sudo apt-get install -f
                    rm ./google-chrome-stable_current_amd64.deb
                    ;;
                "GIMP" ) # install GIMP
                    sudo add-apt-repository ppa:ubuntuhandbook1/gimp
                    sudo apt-get update
                    sudo apt-get install gimp
                    ;;
                * )
                    sudo apt-get install ${Application_dict[$key]}
                    ;;
            esac
        fi
    else
        Echo_Color g "You are already installed ${Application_dict[$key]} before~"
    fi
done

Echo_Color g "Done!! $0"