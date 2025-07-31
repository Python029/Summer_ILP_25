#!/bin/bash

sudo_check()
{
    if [ $EUID -eq 0 ]; then
        while [ true ]; do
            echo "Would you like to execute the script?[y/n]" 
            read -r choice
            if [[ "${choice,,}" == "y" || "${choice,,}" == "yes" ]]; then
                echo -e "\n"
                break
            elif [[ "${choice,,}" == "n" || "${choice,,}" == "no" ]]; then
                exit 1
            else
                echo "Invalid Response"
            fi
        done
    else
        echo "Admin permissions required"
        exit 1
    fi
}

sudo_check

SSID=$(iwgetid -r)
IP=$(hostname -I)
MAC=$(ifconfig wlan0 | grep ether | awk 'NR==1 {print $2}')

echo -e "SSID: $SSID\nIP: $IP\nMAC: $MAC\n"

echo "Please enter a new ip address on the local network:" 

enter_IP()
{
    read -p "192.168.1." newIP
    newIP=192.168.1.$newIP
    echo -e "\nChecking IP availability...\n"
}

enter_IP
while [ true ]; do


    if [[ "$(ping -c1 $newIP)" == *"Destination"* ]]; then
        echo -e "IP Available\nChanging IP address..."
        break
    elif [[ "$(ping -c1 $newIP)" == *"ttl"* ]]; then
        echo -e "IP Unavaiable\nTry again:"
        enter_IP
    fi
done

sudo nmcli con mod $SSID ipv4.addresses $newIP/24
sudo nmcli con up $SSID 

echo -e "New IP confirmed:\n$(hostname -I)"


while [ true ]; do
    echo -e "Would you like to change your MAC address as well?[y/n]"
    read -r choice
            

    if [[ "${choice,,}" == "y" || "${choice,,}" == "yes" ]]; then
        break
    elif [[ "${choice,,}"=="n" || "${choice,,}"=="no" ]]; then
        exit 0
    else
        echo "Invalid Response"
    fi
done

sudo ip link set dev wlan0 down

OUI=${MAC:0:8}
newMac=$(openssl rand -hex 3 | sed 's/\(..\)/\1:/g; s/:$//')
newMac=$OUI:$newMac

sudo ip link set dev wlan0 address $newMac

sudo ip link set dev wlan0 up

echo -e "\nNew mac address confirmed:\n$newMac"



