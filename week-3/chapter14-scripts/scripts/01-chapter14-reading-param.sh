#!/bin/bash
# using one command line parameter
#
factorial=1
for (( number = 1; number <= 1 ; number++ ))
do
factorial=$(($factorial * $number))
done

# Added echo to check the output - it should be 1.
echo $factorial