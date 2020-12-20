#!/usr/bin/env bash
#>            +------------------+
#>            |    package.sh    |
#>            +------------------+
#-
#- SYNOPSIS
#-
#-    ./package.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-
#- EXAMPLES
#-
#-    $ ./package.sh -y

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
sudo apt update
sudo apt upgrade
sudo apt install -y git-all vim curl

# git: config global usr information
Ask_yn "Do you want to config global user information?"; result=$?
if [ $result = 1 ]; then
    printf "Enter your global user name: "; read usr_name
    printf "Enter your global user mail: "; read usr_mail
    git config --global user.name "$usr_name"
    git config --global user.email "$usr_mail"
fi

# git: config vim to the commit editor
Ask_yn "Do you want use VIM to be your editor?"; result=$?
if [ $result = 1 ]; then
    git config --global core.editor vim
fi

# git: add command "git lg"
Ask_yn "Do you want add command: 'git lg'?"; result=$?
if [ $result = 1 ]; then
    FILE_PATH=~/.gitconfig
    Keyword="[alias]"
    CUS_Command='lg = !"git lg2"'

    SRC_arr=("[alias]" "lg1 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all" "lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all" "$CUS_Command")

    function Merge_SRC(){
        local SRC=""
        for key in ${!SRC_arr[*]}; do
            if [ $key -lt $1 ];then
                :
            else 
                SRC="$SRC${SRC_arr[key]}\n"
            fi
        done
        echo "$SRC"
    }

    if [ -f $FILE_PATH ]; then
        if grep -Fn "$Keyword" $FILE_PATH; then
            SRC=$(Merge_SRC 1)
            if grep -n "^lg*=*" $FILE_PATH; then
                echo "You have already added 'git lg' in $FILE_PATH !!"
            else
                printf "%b" "$SRC"
                sed -i "/$Keyword/a $SRC" $FILE_PATH
            fi
        else
            printf "%b" "\n$(Merge_SRC 0)" >> $FILE_PATH
        fi
    else
        printf "%b" "$(Merge_SRC 0)" >> $FILE_PATH
    fi
fi

sudo apt-get autoremove
echo "Done!!"