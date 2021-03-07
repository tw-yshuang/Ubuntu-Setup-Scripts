#!/usr/bin/env bash
#>         +----------------------+
#>         |  terminal-config.sh  |
#>         +----------------------+
#-
#- SYNOPSIS
#-
#-    ./terminal-config.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./terminal-config.sh -y

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

# terminal theme setting
Ask_yn "Do you want to use custom terminal theme setting?"; result=$? # get Ask_yn() 
if [ $result = 1 ]; then
    sudo mkdir ~/.local/share/fonts
    sudo cp ./ttf/*ttf ~/.local/share/fonts
    fc-cache -f -v 
    dconf load /org/gnome/terminal/ < ./config/gnome_terminal_settings_backup.txt
fi

Ask_yn "Do you want to use English for terminal?"; result=$? # get Ask_yn() 
if [ $result = 1 ]; then
    case $SHELL in
        *zsh )
        profile=~/.zshrc
        ;;
        *bash )
        profile=~/.bashrc
        ;;
        *ksh )
        profile=~/.profile
        ;;
        * )
        echo "unknow sehll, need to manually add 'export LANG=C.UTF-8' on your shell profile!!"
        ;;
    esac

    if grep -n "^export LANG*" $profile; then
        echo "You were already config LANG before, if you still want to config it, please manually edit $profile."
    else
        printf "\n#Setting English for terminal\nexport LANG=C.UTF-8\n" >> $profile
        if [[ $SHELL == "*bash" ]]; then
            source $profile
        fi
    fi
fi