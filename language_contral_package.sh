#!/usr/bin/env bash
#>            +-----------------------+
#>            |  custom_functions.sh  |
#>            +-----------------------+
#-
#- SYNOPSIS
#-
#-    ./custom_functions.sh [-h]
#-
#- OPTIONS
#-
#-    -y,                    all accept.
#-    -h, --help             print help information.
#-    -no_nvm                do not build extra function in nvm
#-    -no_pipenv_correspond  do not build pipenv_correspond()
#-    
#-
#- EXAMPLES
#-
#-    $ ./custom_functions.sh -y

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
no_nvm=false
no_pipenv_correspond=false

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
            "-no_nvm")
                no_nvm=true
            ;;
            "-no_pipenv_correspond")
                no_pipenv_correspond=true
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
custom_func_keyword="~/.customfunction"
custom_func_root=~/.customfunction

func_begin_arr=($(grep -xn "^\S*(){" ./config/.customfunction)) # \S: match non-whitespace character
func_end_arr=($(grep -xn "}" ./config/.customfunction))

function Get_function_code(){
    for key in ${!func_end_arr[*]}; do
        if echo ${func_begin_arr[$key]} | grep --silent -i $1; then
          declare -i begin=$(echo ${func_begin_arr[$key]} | cut -d ':' -f 1)-1
          declare -i end=$(echo ${func_end_arr[$key]} | cut -d ':' -f 1)+1
          function_code=$(sed -n "$begin,$end p" ./config/.customfunction)
        fi
    done
}

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
    Echo_Color r "Unknow shell, need to manually add $custom_func_keyword on your shell profile!!"
    ;;
esac

echo '#!/usr/bin/env bash' > $custom_func_root
if grep -n "source $custom_func_keyword" $profile; then
    echo "$custom_func_keyword is already in the $profile"
else
    Echo_Color y "Write: source $custom_func_keyword into $profile"
    printf "\n# custom func. by self\nsource $custom_func_keyword\n" >> $profile
fi

if ! $no_nvm; then
    # delete original nvm setting in the profile
    num_original_line=$(grep -xn 'export NVM_DIR="$HOME/.nvm"' $profile | head -n 1 | cut -d ':' -f 1)
    if [ "$num_original_line" -gt 0 ]; then
        Echo_Color y "remove the office support method..."
        sed -i "$num_original_line, $(($num_original_line + 2))d" $profile
    fi

    Get_function_code "nvm"; printf "\n$function_code\n" >> $custom_func_root
fi

if ! $no_pipenv_correspond; then
    Get_function_code "pipenv_correspond"; printf "\n$function_code\n" >> $custom_func_root
fi

Echo_Color g "Done config!!"
