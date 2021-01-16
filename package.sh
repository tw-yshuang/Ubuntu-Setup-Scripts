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
#-    -no_git-config         do not costom config git.
#-    -no_extra-packages     do not install all the extra-packages.
#-      
#-    =========== extra package options ===========
#-    --no_ssh-server        do not install openssh-server.
#-    --no_screen            do not install screen.
#-    --no_pip3              do not install python3-pip.
#-
#- EXAMPLES
#-
#-    $ ./package.sh -y -no_extra-packages
#-    $ ./package.sh -y -no_git-config --no_ssh-server

#====================================================
# Part 1. Option Tool (DO NOT MODIFY)
#====================================================
# Print script help
function show_script_help(){
    echo
    head -25 $0 | # find this file top 16 lines.
    grep "^#[-|>]" | # show the line that include "#-" or "#>".
    sed -e "s/^#[-|>]*//1" # use nothing to replace "#-" or "#>" that the first keyword in every line.  
    echo 
}
# Receive arguments in slient mode.
#* Design: if you want add some extra packages, please add slient and update Extra_package_dict(under the code slient mode).
all_accept=0
git_config=1
extra_packages=1
ssh_server=1
screen=1
pip3=1
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
            # Not setting ~/.gitconfig
            "-no_git-config")
                git_config=0
                shift 1
            ;;
            # do not install all the extra-packages
            "-no_extra-packages")
                extra_packages=0
                shift 1
            ;;
            # Not install openssh-sever
            "--no_ssh-server")
                ssh_server=0
                shift 1
            ;;
            # Not install screen
            "--no_screen")
                screen=0
                shift 1
            ;;
            # Not install python3-pip
            "--no_pip3")
                pip3=0
                shift 1
            ;;
        esac
    done
fi
declare -A Extra_package_dict
Extra_package_dict=([openssh-server]=$ssh_server [screen]=$screen [python3-pip]=$pip3)

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
sudo apt install -y git-all vim curl wget make

if [ $git_config = 1 ]; then
    # git: config global usr information
    Ask_yn "Do you want to config git global user information?"; result=$?
    if [ $result = 1 ]; then
        printf "Enter your git global user name: "; read usr_name
        printf "Enter your git global user mail: "; read usr_mail
        git config --global user.name "$usr_name"
        git config --global user.email "$usr_mail"
    fi

    # git: config vim to the commit editor
    Ask_yn "Do you want use VIM to be your git commitment editor?"; result=$?
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
fi

# extra packages install
if [ $extra_packages = 1 ]; then
    echo "!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!"
    echo "This is the extra part, some packages may not be useful to you!"
    for key in ${!Extra_package_dict[*]}; do
        if [ ${Extra_package_dict[$key]} = 1 ]; then
            Ask_yn "Do you want to install $key?"; result=$?
            if [ $result = 1 ]; then
                sudo apt install -y $key
            fi
        fi
    done
fi

sudo apt-get autoremove
echo "Done!!"