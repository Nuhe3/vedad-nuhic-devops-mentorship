#!/bin/bash
# testing closing file descriptors
exec 3> test17file
echo "This is a test line of data" >&3
exec 3>&-
cat test17file
exec 3> test17file
echo "This'll be bad" >&3

# $ ./10-chapter15-testing-closing-file.sh
# This is a test line of data
# $ cat test17file
# This'll be bad