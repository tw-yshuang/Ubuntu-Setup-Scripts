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
# Part 1. Option Tool (DO NOT MODIFY)
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

function Ask_yn(){
    printf "$1 [y/n]" 
    if [ $all_accept = 1 ]; then
        printf "-y\n"
        return 1
    fi
    read respond
    if [ "$respond" = "y" -o "$respond" = "Y" -o "$respond" = "" ]; then
        return 1
    elif [ "$respond" = "n" -o "$respond" = "N" ]; then
        return 0
    else
        echo 'wrong command!!'
        Ask_yn $1
        return $?
    fi
    unset respond
}

#====================================================
# Part 2. Main
#====================================================
sudo apt update
sudo apt upgrade

declare -A Application_dict
Application_dict=([code]="VScode" [google-chrome]="Chrome" [vlc]="VLC" [gimp]="GIMP" [kolourpaint]="kolourpaint")

for key in ${!Application_dict[*]}; do
    app_root="$(command -v $key)" # get application root
    if [ "$app_root" = "" ]; then
        Ask_yn "Do you wamt to install ${Application_dict[$key]}?"; result=$? # get Ask_yn() return {Application_dict[$key]}
        if [ $result = 1 ]; then
            case ${Application_dict[$key]} in 
                "VScode" ) # install VScode
                    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > ./packages.microsoft.gpg
                    sudo install -o root -g root -m 644 ./packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
                    sudo apt-get install apt-transport-https -y
                    sudo apt-get update
                    sudo apt-get install code -y
                    rm ./packages.microsoft.gpg
                    ;;
                "Chrome" ) # install Chrome
                    wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                    sudo dpkg -i ./google-chrome-stable_current_amd64.deb
                    sudo apt-get install -f
                    rm ./google-chrome-stable_current_amd64.deb
                    ;;
                "VLC" ) # install VLC
                    sudo apt-get install vlc -y
                    ;;
                "GIMP" )
                    sudo add-apt-repository ppa:ubuntuhandbook1/gimp
                    sudo apt update
                    sudo apt install gimp
                    ;;
                "kolourpaint" )
                    sudo apt install kolourpaint4
                    ;;
            esac
        fi
    else
        echo "You are already installed ${Application_dict[$key]} before~"
    fi
done