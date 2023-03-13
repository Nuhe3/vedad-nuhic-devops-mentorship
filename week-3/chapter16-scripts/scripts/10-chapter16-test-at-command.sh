#!/bin/bash
# Test using at command
#
echo "This script ran at $(date +%B%d,%T)" > test13b.out
echo >> script.out
sleep 5
echo "This is the script's end..." >> script.out
#
