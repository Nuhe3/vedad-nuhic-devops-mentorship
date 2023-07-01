#!/bin/bash
# testing closing file descriptors
exec 3> test17file
echo "This is a test line of data" >&3
exec 3>&-
echo "This won't work" >&3

# $ ./09-chapter15-closing-file-desc.sh
# ./09-chapter15-closing-file-desc.sh: 3: Bad file descriptor