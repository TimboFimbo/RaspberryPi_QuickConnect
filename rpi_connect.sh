#!/bin/bash

## Add as many Pis as you need here,
## then add their variable names to the list below
declare -A Pi_A=( 
    [ip_address]="192.168.0.116" 
    [alt_ip]="" 
    [con_code]="a" 
    [username]="timbo" 
    [pi_name]="AngelPi" 
    [pi_model]="Pi_2" 
    [pi_os]="Raspberry_Pi_OS_Lite_(32-bit)"
    [pi_info]="Online_Radio_Streamer" 
    )

declare -A Pi_B=( 
    [ip_address]="192.168.0.117" 
    [alt_ip]="" 
    [con_code]="b" 
    [username]="timbo" 
    [pi_name]="BostonCreamPi" 
    [pi_model]="Pi_Zero_W" 
    [pi_os]="Raspberry_Pi_OS_Lite_(32-bit)"
    [pi_info]="" 
    )

declare -A Pi_C=( 
    [ip_address]="192.168.0.118" 
    [alt_ip]="" 
    [con_code]="c" 
    [username]="timbo" 
    [pi_name]="ChickenPotPi" 
    [pi_model]="Pi_4_(4GB)" 
    [pi_os]="Raspberry_Pi_OS_Lite_(64-bit)"
    [pi_info]="Jellyfin_Media_Server" 
    )

declare -A Pi_D=( 
    [ip_address]="192.168.0.119" 
    [alt_ip]="" 
    [con_code]="d" 
    [username]="timbo" 
    [pi_name]="DerbyPi" 
    [pi_model]="Pi_Zero_2_W" 
    [pi_os]="Raspberry_Pi_OS_Lite_(32-bit)"
    [pi_info]="" 
    )

declare -A Pi_E=( 
    [ip_address]="192.168.0.120" 
    [alt_ip]="" 
    [con_code]="e" 
    [username]="timbo" 
    [pi_name]="EskimoPi" 
    [pi_model]="Pi_4_(8GB)" 
    [pi_os]="Raspberry_Pi_OS_(64-bit)"
    [pi_info]="" 
    )

## Add the variable names to this list
declare pi_list=( Pi_A Pi_B Pi_C Pi_D Pi_E )

## Do not delete this one - just keep it blank
## There's probably a better way of doing this,
## I just haven't spent the time to look into it
declare -A selected_pi=( 
    [ip_address]="" 
    [con_code]="" 
    [username]="" 
    [pi_name]="" 
    [pi_model]="" 
    [pi_os]=""
    [pi_info]="" 
    )

RED="\e[1;31m"
GREEN="\e[1;32m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
WHITE="\e[0;38m"

declare unformatted_output=""
declare online_status="Checking Pi online status"
declare loading_dots=""
declare return_line="\r"

use_sftp=false
use_sftpr=false
alt_mode=false
quick_mode=false
compact_mode=false
any_pi_online=false

for inp in "$@"
do
    if [ "$inp" = "-a" ]
    then
        alt_mode=true
    fi

    if [ "$inp" = "-q" ]
    then
        quick_mode=true
    fi

    if [ "$inp" = "-c" ]
    then
        compact_mode=true
    fi

    if [ "$inp" = "-fr" ]
    then
        use_sftpr=true
    elif [ "$inp" = "-f" ]
    then
        use_sftp=true
    fi
done

if [ "$compact_mode" = false ]
then
    echo -e "${YELLOW}\nWelcome to Raspberry Pi Quick Connect${WHITE}\n"
    echo -e "You can start the program with the following arguments:\n"
    echo -e "    -f to use SFTP (for file transfers)"
    echo -e "    -fr to use SFTP with recursive mode on (for folder transfers)"
    echo -e "    -a to use alt ip addresses, if available (alt addresses marked with *)"
    echo -e "    -q to use quick mode (won't check for Pi online status)"
    echo -e "    -c to use compact mode (limited info, good for small screens)\n"
else
    echo -e "${YELLOW}\nRaspberry Pi Quick Connect${WHITE}\n"
fi

if [ "$quick_mode" = false ]
then
    echo -e -n $online_status$loading_dots$return_line
fi

for pi in "${pi_list[@]}"
do
    declare -n this_pi="$pi"
    pi_online="-"
    pi_ip=""

    if [ "$alt_mode" = true -a -n "${this_pi[alt_ip]}" ]
    then
        if [ "$compact_mode" = false ]
        then
            pi_ip="${this_pi[alt_ip]}*"
        fi
        if [ "$quick_mode" = false ]
        then
            loading_dots+="."
            echo -e -n $online_status$loading_dots$return_line
            if ping -c 1 "${this_pi[alt_ip]}" &> /dev/null
            then
                pi_online="Online"
                any_pi_online=true
            fi
        fi
    else
        if [ "$compact_mode" = false ]
        then
            pi_ip="${this_pi[ip_address]}"
        fi
        if [ "$quick_mode" = false ]
        then
            loading_dots+="."
            echo -e -n $online_status$loading_dots$return_line
            if ping -c 1 "${this_pi[ip_address]}" &> /dev/null
            then
                pi_online="Online"
                any_pi_online=true
            fi
        fi
    fi

    if [ "$quick_mode" = false ]
    then
        if [ "$pi_online" = "Online" ]
        then 
            unformatted_output+="${GREEN}"
        else 
            unformatted_output+="${RED}"
        fi
    else 
        unformatted_output+="${CYAN}"
    fi


    unformatted_output+=" | "" ${this_pi[con_code]}""^|"
    unformatted_output+="  ${this_pi[pi_name]}""^|"
    if [ "$compact_mode" = false ]
    then
        unformatted_output+="  $pi_ip""^|"
    fi

    if [ "$compact_mode" = false ]
    then
        unformatted_output+="  ${this_pi[pi_model]}""^ | "
        unformatted_output+="  ${this_pi[pi_os]}""^ | "
    fi

    if [ "$quick_mode" = false ]
    then
        unformatted_output+="  $pi_online""^ | "
    fi

    if [ "$compact_mode" = false -a -n "${this_pi[pi_info]}" ]
    then
        unformatted_output+="  ${this_pi[pi_info]}""^ |"
    fi
    unformatted_output+="${WHITE}"
    unformatted_output+=$'\n'
done
printf "$unformatted_output" | column -ts $'^'
echo ""

if [ "$any_pi_online" = false -a "$quick_mode" = false ]
then
    echo -e "No Pi Online. Quitting\n"
    exit 0
else
    if [ "$use_sftpr" = true ]
    then
        if [ "$compact_mode" = false ]
        then
            echo -e "Enter a letter to SFTP into Raspberry Pi, with Recursive mode on"
        else
            echo -e "Enter a letter to use sftp -r"
        fi
    elif [ "$use_sftp" = true ]
    then
        if [ "$compact_mode" = false ]
        then
            echo -e "Enter a letter to SFTP into Raspberry Pi"
        else
            echo -e "Enter a letter to use sftp"
        fi
    else
        if [ "$compact_mode" = false ]
        then
            echo -e "Enter a letter to SSH into Raspberry Pi"
        else
            echo -e "Enter a letter to use ssh"
        fi
    fi
fi

pi_found=false

read letter

# Could probably do this loop better, without expicitly mentioning variable names
for pi in "${pi_list[@]}"
do
    declare -n this_pi="$pi"
    if [ $pi_found=false ]
    then
        if [ "$letter" = "${this_pi[con_code]}" ]
        then
            selected_pi[con_code]="${this_pi[con_code]}"
            selected_pi[username]="${this_pi[username]}"

            if [ "$alt_mode" = true -a -n "${this_pi[alt_ip]}" ]
            then
                selected_pi[ip_address]="${this_pi[alt_ip]}"
            else
                selected_pi[ip_address]="${this_pi[ip_address]}"
            fi

            selected_pi[pi_name]="${this_pi[pi_name]}"
            selected_pi[pi_model]="${this_pi[pi_model]}"
            selected_pi[pi_os]="${this_pi[pi_os]}"
            selected_pi[pi_info]="${this_pi[pi_info]}"
            pi_found=true
        fi
    fi
done

if [ "$pi_found" = false ]
then
    if [ -n "$letter" ]
    then
        echo ""
    fi
    echo -e "No matching Pi. Quitting\n"
    exit 0
fi

echo -e "\nConnecting to ""${selected_pi[pi_name]}""..."

connection_string="${selected_pi[username]}""@""${selected_pi[ip_address]}"

if [ "$use_sftpr" = true ]
then
    sftp -r $connection_string
elif [ "$use_sftp" = true ]
then
    sftp $connection_string
else
    ssh $connection_string
fi
exit 0