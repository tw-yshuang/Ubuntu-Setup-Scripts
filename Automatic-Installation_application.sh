#!/bin/zsh
sudo apt update
sudo apt upgrade

function Ask_install(){
    printf "Do you wamt to install $1?[y/n]"
    read respond
    if [ "$respond" = "y" -o "$respond" = "Y" ]; then
        return 1
    elif [ "$respond" = "n" -o "$respond" = "N" ]; then
        return 0
    else
        echo 'wrong command!!'
        Ask_install $1
        return $?
    fi
    unset respond
}

declare -A Application_dict
Application_dict=([code]="VScode" [google-chrome]="Chrome" [vlc]="VLC")

for key value in ${(kv)Application_dict[*]}; do
    app_root="$(which $key)" # get application root
    if [ "$app_root" = "$key not found" ]; then
        Ask_install $value
        result=$? # get Ask_install() return value
        if [ $result = 1 ]; then
            case $key in 
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
                    sudo apt-get install vlc
                    ;;
            esac
        fi
    else
        echo "You are already installed $value before~"
    fi
done

# sudo apt-get autoremove

# # install pyenv
# sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm
# curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash



