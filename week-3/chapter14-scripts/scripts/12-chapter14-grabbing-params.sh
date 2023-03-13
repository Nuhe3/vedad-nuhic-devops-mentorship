#!/bin/bash
# Grabbing the last parameter
#
params=$#
echo
echo The last parameter is $params
echo The last parameter is ${!#}
echo

# bash 12-chapter14-grabbing-params.sh  1 2 3 4 5