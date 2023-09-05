#!/bin/bash

## Add as many Pis as you need here,
## then add their variable names to the list below
declare -A Pi_A=( 
    [ip_address]="192.168.0.116" 
    [con_code]="a" 
    [username]="timbo" 
    [pi_name]="AngelPi" 
    [pi_model]="Pi_2" 
    [pi_os]="Raspberry_Pi_OS_Lite_(32-bit)"
    [pi_info]="Online_Radio_Streamer" 
    )

declare -A Pi_B=( 
    [ip_address]="192.168.0.117" 
    [con_code]="b" 
    [username]="timbo" 
    [pi_name]="BostonCreamPi" 
    [pi_model]="Pi_Zero_W" 
    [pi_os]="Raspberry_Pi_OS_Lite_(32-bit)"
    [pi_info]="" 
    )

declare -A Pi_C=( 
    [ip_address]="192.168.0.118" 
    [con_code]="c" 
    [username]="timbo" 
    [pi_name]="ChickenPotPi" 
    [pi_model]="Pi_4_(4GB)" 
    [pi_os]="Raspberry_Pi_OS_Lite_(64-bit)"
    [pi_info]="Jellyfin_Media_Server" 
    )

declare -A Pi_D=( 
    [ip_address]="192.168.0.119" 
    [con_code]="d" 
    [username]="timbo" 
    [pi_name]="DerbyPi" 
    [pi_model]="Pi_Zero_2_W" 
    [pi_os]="Raspberry_Pi_OS_Lite_(32-bit)"
    [pi_info]="" 
    )

declare -A Pi_E=( 
    [ip_address]="192.168.0.120" 
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

declare unformatted_output=""

use_sftp=false
use_sftpr=false
for inp in "$@"
do
    if [ "$inp" = "-fr" ]
    then
        use_sftpr=true
    elif [ "$inp" = "-f" ]
    then
        use_sftp=true
    fi
done

if [ "$use_sftpr" = true ]
then
    echo -e "\nEnter a letter to SFTP into Raspberry Pi, with Recursive mode on"
elif [ "$use_sftp" = true ]
then
    echo -e "\nEnter a letter to SFTP into Raspberry Pi"
else
    echo -e "\nEnter a letter to SSH into Raspberry Pi"
    echo -e "You can also restart with -f to use SFTP, or -fr to use SFTP with Recursive mode on"
fi

echo ""
for pi in "${pi_list[@]}"
do
    declare -n this_pi="$pi"
    unformatted_output+=" | ""${this_pi[con_code]}"" | "
    unformatted_output+="${this_pi[pi_name]}"" | "
    unformatted_output+="${this_pi[ip_address]}"" | "
    unformatted_output+="${this_pi[pi_model]}"" | "
    unformatted_output+="${this_pi[pi_os]}"" | "
    if [ ! -z "${this_pi[pi_info]}" ]
    then
        unformatted_output+="${this_pi[pi_info]}"" | "
    fi
    unformatted_output+=$'\n'
done
echo "$unformatted_output" | column -t
echo ""

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
            selected_pi[ip_address]="${this_pi[ip_address]}"
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
    echo -e "\nNo matching Pi. Quitting"
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