#!/bin/bash

# Launch processes in the background
/home/parallels/recovery_script.sh > /tmp/stdout1.log 2> /tmp/stderr1.log &
ping 8.8.8.8 > /tmp/stdout2.log 2> /tmp/stderr2.log &
service apache2 start > /tmp/stdout3.log 2> /tmp/stderr3.log &

# Store the process IDs
pid1=$!
pid2=$!
pid3=$!

echo "Processes launched with the following IDs:"
echo "Process 1: $pid1"
echo "Process 2: $pid2"
echo "Process 3: $pid3"

# Wait for user input to send signals
read -p "Press any key to send SIGINT to Process 1: " key
kill -SIGINT $pid1

read -p "Press any key to send SIGTERM to Process 2: " key
kill -SIGTERM $pid2

read -p "Press any key to send SIGKILL to Process 3: " key
kill -SIGKILL $pid3
