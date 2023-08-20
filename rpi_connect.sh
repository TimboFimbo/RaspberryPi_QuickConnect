#!/bin/bash

pi_a_con="timbo@192.168.0.116"
pi_b_con="timbo@192.168.0.117"
pi_c_con="timbo@192.168.0.118"
pi_d_con="timbo@192.168.0.119"

selected_pi=$pi_a_con

use_sftp=false
for inp in "$@"
do
    if [ "$inp" = "-f" ]
    then
        use_sftp=true
    fi
done

if [ "$use_sftp" = true ]
then
    echo -e "\nEnter a letter to SFTP into Raspberry Pi\n"
else
    echo -e "\nEnter a letter to SSH into Raspberry Pi (restart with -f to SFTP instead)\n"
fi

echo "  a : AngelPi       | Pi 2        | Raspberry Pi OS Lite (32-bit)"
echo "  b : BostonCreamPi | Pi Zero W   | Raspberry Pi OS Lite (32-bit)"
echo "  c : ChickenPotPi  | Pi 4 (4GB)  | Raspberry Pi OS Lite (64-bit)"
echo "  d : DerbyPi       | Pi Zero 2 W | Raspberry Pi OS Lite (32-bit)"

read letter

if [ "$letter" = 'a' ] || [ "$letter" = 'A' ]
then
    echo -e "\nConnecting to AngelPi..."
elif [ "$letter" = 'b' ] || [ "$letter" = 'B' ]
then
    echo -e "\nConnecting to BostonCreamPi..."
    selected_pi=$pi_b_con
elif [ "$letter" = 'c' ] || [ "$letter" = 'C' ]
then
    echo -e "\nConnecting to ChickenPotPi..."
    selected_pi=$pi_c_con
elif [ "$letter" = 'd' ] || [ "$letter" = 'D' ]
then
    echo -e "\nConnecting to DerbyPi..."
    selected_pi=$pi_d_con
else
    echo -e "\nNo matching Pi. Quitting"
    exit 0
fi

if [ "$use_sftp" = true ]
then
    sftp $selected_pi
else
    ssh $selected_pi
fi
exit 0