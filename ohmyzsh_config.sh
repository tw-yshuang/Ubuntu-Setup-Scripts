#!/usr/bin/env zsh
#>         +---------------------+
#>         |  ohmyzsh-config.sh  |
#>         +---------------------+
#-
#- SYNOPSIS
#-
#-    ./ohmyzsh-config.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./ohmyzsh-config.sh -y

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
source ~/.zshrc
declare -A Ohmyzsh_config_dict
Ohmyzsh_config_dict=([powerlevel10k]=https://github.com/romkatv/powerlevel10k.git [zsh-autosuggestions]=https://github.com/zsh-users/zsh-autosuggestions.git [zsh-syntax-highlighting]=https://github.com/zsh-users/zsh-syntax-highlighting.git)

Ohmyzsh_config=""
write_plugins=0
for key in ${(k)Ohmyzsh_config_dict}; do
    Ask_yn "Do you want to install and use $key?"; result=$? # get Ask_yn() 
    if [ $result = 1 ]; then
        if [ "$key" = "powerlevel10k" ]; then 
            sudo git clone ${Ohmyzsh_config_dict[$key]} $ZSH_CUSTOM/themes/$key
            sed -i 's!^ZSH_THEME=.*!ZSH_THEME="powerlevel10k/powerlevel10k"!' ~/.zshrc
            printf "%b" "\n\n# To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh.\n[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh\n" >> ~/.zshrc
        else
            sudo git clone ${Ohmyzsh_config_dict[$key]} $ZSH_CUSTOM/plugins/$key
            Ohmyzsh_config="$Ohmyzsh_config $key"
            write_plugins=1
        fi
    fi
done

# use sed to edit ~/.p10k.zsh
Ask_yn "Do you want to use customize p10k setting?"; result=$? # get Ask_yn() 
if [ $result = 1 ]; then
    cp ./config/.p10k.zsh ~/
fi

# use sed to edit ~/.zshrc
if [ $write_plugins = 1 ]; then
    sed -i "s/^plugins.*/plugins=(git$Ohmyzsh_config)/" ~/.zshrc
    source ~/.zshrc
fi

Echo_Color g "Done!! $0"