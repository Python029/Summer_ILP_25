#!/bin/bash

echo "Hello $USER"
echo "Beginning Google Ping Script"
ping -c 5 8.8.8.8 | awk 'NR>=2 && NR<=6 {print $5}'
