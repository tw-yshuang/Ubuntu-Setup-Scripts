#!/usr/bin/env bash
#>            +----------------+
#>            |  nvm_setup.sh  |
#>            +----------------+
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
        printf "-y\n"
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
Keyword='nvm() {
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
    Echo_Color r "Unknow shell, need to manually add nvm config on your shell profile!!"
    ;;
esac

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | $shell

# config profile
Ask_yn "Do you want to use costom nvm setting?"; result=$?
if [ $result = 1 ]; then
    # use comment to detect is already exist or not
    if grep -xn '# costomize nvm setting' $profile; then
        echo "You already have costomize nvm setting in $profile !!"
    else
        # delete original nvm setting in the profile
        original_line=$(grep -xn 'export NVM_DIR="$HOME/.nvm"' $profile | head -n 1 | cut -d ':' -f 1)
        sed -i "$original_line, $(($original_line + 2))d" $profile
        # import costomize nvm setting
        printf "\n# customize nvm setting\n$Keyword\n" >> $profile
    fi
    Echo_Color g "Done config!!"
    source $profile
fi

Echo_Color g "Done!! $0"