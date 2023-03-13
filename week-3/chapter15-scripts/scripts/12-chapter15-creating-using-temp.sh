#!/bin/bash
# creating and using a temp file

tempfile=$(mktemp test19.XXXXXX)
exec 3>$tempfile
echo "This script writes to temp file $tempfile"
echo "This is the first line" >&3
echo "This is the second line." >&3
echo "This is the last line." >&3
exec 3>&-
echo "Done creating temp file. The contents are:"
cat $tempfile
rm -f $tempfile 2> /dev/null


# $ ./test19
# This script writes to temp file test19.vCHoya
# Done creating temp file. The contents are:
# This is the first line
# This is the second line.
# This is the last line.