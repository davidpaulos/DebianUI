#!/bin/bash

function update
{
		sudo apt-get upgrade
}

function install 
{
	local pkg
	local argument_input	
	pkg="$( apt-cache search "" | sort -k1,1 -u | 
		fzf -i \
                    --multi \
                    --exact \
                    --no-sort \
                    --select-1 \
                    --query="$argument_input" \
                    --cycle \
                    --reverse \
                    --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --preview 'apt-cache show {1} '\
                    --preview-window=right:55%:wrap \
                    --header="TAB key to (un)select. ENTER to install. ESC to quit." \
                    --prompt="filter> " |
                awk '{print $1}'                                                  
            )"
            
            pkg="$( echo "$pkg" | paste -sd " " )"
            if [[ -n "$pkg" ]]
            then 
            clear
            sudo apt-get install $pkg
            fi
}

function purge
{
	local pkg
	local argument_input	
	pkg="$( dpkg --get-selections | grep -v deinstall | sort -k1,1 -u | 
		fzf -i \
                    --multi \
                    --exact \
                    --no-sort \
                    --select-1 \
                    --query="$argument_input" \
                    --cycle \
                    --reverse \
                    --margin="4%,1%,1%,2%" \
                    --inline-info \
                    --preview 'apt-cache show {1} '\
                    --preview-window=right:55%:wrap \
                    --header="TAB key to (un)select. ENTER to purge. ESC to quit." \
                    --prompt="filter> " |
                awk '{print $1}'                                                  
            )"
            
            pkg="$( echo "$pkg" | paste -sd " " )"
            if [[ -n "$pkg" ]]
            then 
            clear
            sudo apt-get purge $pkg
            fi
}

function maintain
{
	sudo apt-get autoclean
	sudo apt-get autoremove
	sudo apt-get update –fix-missing	
	}

function ui
{
while true
do
clear
echo
    echo -e "                     \e[7m DebianUI - Package manager \e[0m                     "
    echo -e " ┌───────────────────────────────────────────────────────────────┐"
    echo -e " │    1   \e[1mU\e[0mpdate System           2   \e[1mM\e[0maintain System            │"
    echo -e " │    3   \e[1mI\e[0mnstall Packages        4   \e[1mP\e[0murge package              │"
    echo -e " └───────────────────────────────────────────────────────────────┘"
    
    echo -e "  Enter number or marked letter(s)   -   0   \e[1mQ\e[0muit "
    read -r choice
    choice="$(echo "$choice" | tr '[:upper:]' '[:lower:]' )"
    echo
    
    case "$choice" in
        1|u|update|update-system )
            update                                                                 
            echo
            echo -e " \e[41m System updated. To return to debianUI press ENTER \e[0m"
            # wait for input, e.g. by pressing ENTER:
            read
            ;;
        2|m|maintain|maintain-system )
            maintain
            echo
            echo -e " \e[41m System maintenance finished. To return to debianUI press ENTER \e[0m"
            read
            ;;
        3|i|install|install-packages )
            install
            echo
            echo -e " \e[41m Package installation finished. To return to debianUI press ENTER \e[0m"
            read
            ;;
        4|r|remove|remove-packages-and-deps )
            purge
            echo
            echo -e " \e[41m Package(s) purged. To return to debianUI press ENTER \e[0m"
            read
            ;;
        0|q|quit|$'\e'|$'\e'$'\e' )
        clear && exit
            ;;
            
            * )                                                                         
            echo -e " \e[41m Wrong option \e[0m"
            echo -e "  Please try again...  "
            sleep 2
            ;;
            
      esac   
      done
	}
	
ui
