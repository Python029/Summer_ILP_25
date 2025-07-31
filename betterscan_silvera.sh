#!/bin/bash

gateway=$(arp -n | awk 'NR==2 {print $1}')
bit=$(ip addr show wlan0 | awk 'NR==3 {print $2}' | xargs -I @ basename @)
file="nmapresults1.txt"
#------------------------------------------------------------------------
echo "|     IP Address    |      MAC Address      |        Device Type        |"
echo "=========================================================================" 

sudo_check()
{
    if [ "$EUID" -ne 0 ]; then
        echo "Must run as root"
        exit 1
    fi

}


scan()
{
    sudo nmap -sn $gateway/$bit > $file
    sed -i '1d' $file
}



sudo_check
scan
i=0
while [ 1 ]; do

    IP=$(awk "NR==($(($i*3)) + 1) {print \$5} " $file )
    if [ $IP == $(hostname -I | awk '{print $1}') ]; then
        break
    fi

    MAC=$(awk "NR==($(($i*3)) + 3) {print \$3} " $file )
    TYPE=$(awk "NR==($(($i*3)) + 3) " $file | cut -d "(" -f2 | cut -d ")" -f1 )
    echo -e "     $IP\t$MAC\t$TYPE"
    
    ((i++))
    
    done
file="nmapresults2.txt"


while [ 1 ]; do
    
    echo "Would you like to add another device to the network? [y/n]"
    read -r choice

    if [[ "${choice,,}" == "y" ]]; then
        echo "Performing another scan in 60 seconds"
        break
    elif [[ "${choice,,}" == "n" ]]; then
        exit 0
    else
        echo "Invalid Response"
    fi

done

sleep 10s
scan

echo "Changes:
diff nmapresults1.txt nmapresults2.txt | grep -v "Host" | grep -v "done" | grep '^[<>]'
