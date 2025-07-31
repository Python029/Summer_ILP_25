#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Must run as root"
    exit 1
fi




log="/home/$(logname)/Desktop/rmlog.txt"




echo "File you want to remove:"
read -p "/home/$(logname)/" file 

rm /home/$(logname)/$file


echo "User: $(logname)" >> $log
echo "File Deleted: $file" >> $log
echo "Timestamp: $(date)" >> $log
echo "===================================" >> $log

echo -e "\nFile Deleted\n"
