#!/usr/bin/env bash
#>         +----------------------+
#>         |    pyenv_setup.sh    |
#>         +----------------------+
#-
#- SYNOPSIS
#-
#-    ./pyenv_setup.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./pyenv_setup.sh -y

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
Keyword='# pyenv setting
PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"'
case $SHELL in
    *zsh )
    shell=zsh
    profile=~/.zshrc
    ;;
    *bash )
    shell=bash
    profile=~/.bashrc
    ;;
    *ksh )
    shell=ksh
    profile=~/.profile
    ;;
    * )
    echo "unknow sehll, need to manually add pyenv config on your shell profile!!"
    ;;
esac

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# config profile
Ask_yn "Do you want automatic add pyenv config?"; result=$?
if [ $result = 1 ]; then
    if grep -Fn "$Keyword" $profile; then
        echo "You have already added pyenv config in $profile !!"
    else
        printf "\n$Keyword\n" >> $profile
    fi
    echo "Done!!"
    
    if [ $shell = bash ]; then
        source $profile
    else
        exec $shell
    fi
fi
