#!/usr/zsh
#>                           +-----------------------------------------+
#>                           |  Automatic-Installation_application.sh  |
#>                           +-----------------------------------------+
#- SYNOPSIS
#-
#-    Automatic-Installation_application.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./Automatic-Installation_application.sh -y


# Print script help
function show_script_help(){
    echo 
    head -15 $0 | grep -e "^#[-|>]" | sed -e "s/^#[-|>]*/ /g"
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

if [ "$1" = "-y" ]; then
    all_accept=1
else
    all_accept=0
fi

function Ask_yn(){
    printf "$1 [y/n]" 
    if [ $all_accept = 1 ]; then
        printf "-y"
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

sudo apt update
sudo apt upgrade

declare -A Application_dict
Application_dict=([code]="VScode" [google-chrome]="Chrome" [vlc]="VLC")

for key value in ${(kv)Application_dict[*]}; do
    app_root="$(command -v $key)" # get application root
    if [ "$app_root" = "" ]; then
        Ask_install "Do you wamt to install $value"; result=$? # get Ask_install() return value
        if [ $result = 1 ]; then
            case $value in 
                $Application_dict[code]) # install VScode
                    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
                    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
                    sudo apt-get install apt-transport-https -y
                    sudo apt-get update
                    sudo apt-get install code -y
                    ;;
                $Application_dict[google-chrome]) # install Chrome
                    wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                    sudo dpkg -i google-chrome-stable_current_amd64.deb
                    sudo apt-get install -f
                    ;;
                $Application_dict[vlc]) # install VLC
                    sudo apt-get install vlc -y
                    ;;
            esac
        fi
    else
        echo "You are already installed $value before~"
    fi
done