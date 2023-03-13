#!/bin/bash
# demonstrating the shift command
echo
count=1
while [ -n "$1" ]
do
    echo "Parameter #$count = $1"
    count=$[ $count + 1 ]
    shift
done

# bash 15-chapter14-being-shifty.sh vedad dragan dzenan boris