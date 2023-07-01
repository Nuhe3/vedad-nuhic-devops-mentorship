#!/bin/bash
# iterate through all the files in a directory

for file in /home/centos/vedad-nuhic-week-3

     do

if [ -d "$file" ]

    then

    echo "$file is a directory"

elif [ -f "$file" ]

    then

    echo "$file is a file"

    fi

done

