echo "SSID: $(iwgetid -r)"

echo "IP Address: $(hostname -I)"

gateway=$(arp -n | awk 'NR==2 {print $1}')
echo "Router IP: $gateway"

net=$(ifconfig | grep netmask | awk 'NR==2 {print $4}')
echo "Netmask: $net"

bit=$(ip addr show wlan0 | awk 'NR==3 {print $2}' | xargs -I @ basename @)
echo "Bit Network: $bit" 

mac=$(ifconfig wlan0 | grep ether | awk 'NR==1 {print $2}')
echo "MAC Address: $mac"

interface=$(ip route show | awk 'NR==1 {print $5}')
echo "Network Interface: $interface"
