#!/usr/bin/env bash
#>         +----------------------+
#>         |    nvm_setup.sh    |
#>         +----------------------+
#-
#- SYNOPSIS
#-
#-    ./nvm_setup.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./nvm_setup.sh -y

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
Keyword='
nvm() {
  echo "🚨 NVM not loaded! Loading now..."
  unset -f nvm
  export NVM_PREFIX="$HOME/.nvm"
  [ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"
  nvm "$@"
}'
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
    echo "unknow sehll, need to manually add nvm config on your shell profile!!"
    ;;
esac

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | $shell

# config profile
Ask_yn "Do you want automatic add nvm config?"; result=$?
if [ $result = 1 ]; then
    if grep -xn "$Keyword" $profile; then
        echo "You have already added nvm config in $profile !!"
    else
        printf "\n# nvm setting\n$Keyword\n" >> $profile
    fi
    echo "Done!!"
    
    if [ $shell = bash ]; then
        source $profile
    else
        exec $shell
    fi
fi
