#!/bin/zsh
sudo apt update
sudo apt upgrade
sudo apt install -y git-all vim curl


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

# git config global usr information
Ask_yn "Do you want to config global user information?"; result=$?
if [ $result = 1 ]; then
    printf "Enter your global user name: "; read usr_name
    printf "Enter your global user mail: "; read usr_mail
    git config --global user.name "$usr_name"
    git config --global user.email "$usr_mail"
fi

# git config vim to the commit editor
Ask_yn "Do you want use VIM to be your editor?"; result=$?
if [ $result = 1 ]; then
    git config --global core.editor vim
fi

#TODO: add command "git lg"

# [alias]
# lg1 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
# lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all
# lg = !"git lg1"

sudo apt-get autoremove
echo "Done!!"