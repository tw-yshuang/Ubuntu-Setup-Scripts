#!/usr/bin/env bash
#>         +---------------------------+
#>         |    language_package.sh    |
#>         +---------------------------+
#-
#- SYNOPSIS
#-
#-    ./language_package.sh [-h]
#-    
#-    It will intatll Language Packages below:
#-        Python : pyenv, pipenv
#-        NodeJS : nvm
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./language_package.sh -y

#====================================================
# Part 1. Option Tool
#====================================================
# Print script help
function show_script_help(){
    echo
    head -22 $0 | # find this file top 16 lines.
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

function Ask_yn(){
    printf "\e[33m$1\e[0m\e[33m [y/n] \e[0m"
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
pyenv_Keyword='eval "$(pyenv init -)"'
pyenv_Keyword_login='export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"'

pipenv_Keyword='export PATH=~/.local/bin:$PATH'

case $SHELL in
    *zsh )
    shell=zsh
    profile=~/.zshrc
    login_profile=~/.zprofile
    ;;
    *bash )
    shell=bash
    profile=~/.bashrc
    login_profile=~/.bash_profile
    ;;
    *ksh )
    shell=ksh
    profile=~/.profile
    ;;
    * )
    Echo_Color r "Unknow shell, need to manually add pyenv config on your shell profile!!"
    ;;
esac

Ask_yn "Do you want to install pyenv"; result=$?
if [ $result = 1 ]; then
    sudo apt-get update
    sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv

    if [ "$(grep -xn "$pyenv_Keyword" $profile)" != "" ]; then
        Echo_Color g "You have already added pyenv config in $profile !!"
    else
        # config profile
        printf "\n# pyenv setting\n$pyenv_Keyword\n" >> $profile
    fi

    if [ "$(grep -xn "$pyenv_Keyword_login" $profile_login)" != "" ]; then
        Echo_Color g "You have already added pyenv config in $profile_login !!"
    else
        # config login_profile
        printf "\n# pyenv setting\n$pyenv_Keyword_login\n" >> $login_profile
    fi
fi

Ask_yn "Do you want to install pipenv?"; result=$?
if [ $result = 1 ]; then
    pip install --user pipenv
    if [ "$(grep -xn "$pipenv_Keyword" $profile)" != "" ]; then
        Echo_Color g "You have already added pipenv PATH in $profile !!"
    else
        # config profile
        printf "\n# pipenv setting\n$pipenv_Keyword\n" >> $profile
    fi
fi

Ask_yn "Do you want to install nvm?"; result=$?
if [ $result = 1 ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | $shell
fi


source $profile
Echo_Color g "Done!! $0"