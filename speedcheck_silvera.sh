file="speed_results.txt"

(speedtest-cli) > $file

download=$(grep Mbit $file | awk 'NR==1 {print $2}')
upload=$(grep Mbit $file | awk 'NR==2 {print $2}')
ip=$(grep "Testing from" $file | cut -d "(" -f2 | cut -d ")" -f1)
location=$(grep Hosted $file | cut -d "(" -f2 | cut -d ")" -f1)


echo -e "Date:    \t$(date)"
echo -e "IP:      \t$ip"
echo -e "Location:\t$location"
echo -e "Download:\t$download"
echo -e "Upload:  \t$upload"

if [[ $(echo "$download < 40" | bc -l) -eq 1 ]]; then
    echo -e "\nThis network sucks, choose a different one"
else
    echo -e "\nNetwork is great, keep using it!"
fi


exit 0
