#!/bin/bash

file="sshlog.txt"

if [ "$EUID" -ne 0 ]; then
    echo "Must run as root"
    exit 1
fi


journalctl -u ssh | grep -E "Accepted|Failed" >> $file

lines=$(wc -l < $file)

echo "|       Time        |     User     |         IP         |    Status    |   Port   |"
echo "==================================================================================="
begin=0

print_loop()
{
    for (( i=$begin; i<$lines; i++ )); do
        USER=$(awk "NR==($i+1) {print \$4} " $file )
        IP=$(awk "NR==($i+1) {print \$11} " $file )
        PORT=$(awk "NR==($i+1) {print \$13} " $file )
        TIME=$(awk "NR==($i+1) {print \$1, \$2, \$3} " $file)
        STATUS=$(awk "NR==($i+1) {print \$6} " $file)        

        echo -e "   $TIME\t$USER\t$IP\t    $STATUS\t   $PORT"
    
    done
}

if (( lines > 20 )); then
   begin=$((lines-20))   
   print_loop
else
    print_loop
fi
