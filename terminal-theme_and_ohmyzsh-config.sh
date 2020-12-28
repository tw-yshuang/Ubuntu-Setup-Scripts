#!/usr/bin/env zsh
#>         +----------------------------------------+
#>         |  terminal-theme_and_ohmyzsh-config.sh  |
#>         +----------------------------------------+
#-
#- SYNOPSIS
#-
#-    ./terminal-theme_and_ohmyzsh-config.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./terminal-theme_and_ohmyzsh-config.sh -y

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
source ~/.zshrc
declare -A Ohmyzsh_config_dict
Ohmyzsh_config_dict=([powerlevel10k]=https://github.com/romkatv/powerlevel10k.git [zsh-autosuggestions]=https://github.com/zsh-users/zsh-autosuggestions.git [zsh-syntax-highlighting]=https://github.com/zsh-users/zsh-syntax-highlighting.git)

Ohmyzsh_config=""
write_plugins=0
for key in ${(k)Ohmyzsh_config_dict}; do
    Ask_yn "Do you want to install and use $key?"; result=$? # get Ask_ys() 
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

# use sed to edit ~/.zshrc
if [ $write_plugins = 1 ]; then
    sed -i "s/^plugins.*/plugins=(git$Ohmyzsh_config)/" ~/.zshrc
    source ~/.zshrc
fi

# use sed to edit ~/.p10k.zsh
Ask_yn "Do you want to use custom p10k setting?"; result=$? # get Ask_ys() 
if [ $result = 1 ]; then
    cp ./config/.p10k.zsh ~/
fi

# terminal theme setting
Ask_yn "Do you want to use custom terminal theme setting?"; result=$? # get Ask_ys() 
if [ $result = 1 ]; then
    sudo cp ./ttf/*ttf ~/.local/share/fonts
    fc-cache -f -v 
    dconf load /org/gnome/terminal/ < ./config/gnome_terminal_settings_backup.txt
fi