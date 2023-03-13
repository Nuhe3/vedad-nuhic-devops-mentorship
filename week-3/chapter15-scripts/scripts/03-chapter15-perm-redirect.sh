#!/bin/bash
# redirecting output to different locations
exec 2>testerror
echo "This is the start of the script"
echo "now redirecting all output to another location"
15
exec 1>testout
echo "This output should go to the testout file"
echo "but this should go to the testerror file" >&2

# Expected output
# $ ./03-chapter15-perm-redirect.sh
# This is the start of the script
# now redirecting all output to another location
# $ cat testout
# This output should go to the testout file
# $ cat testerror
# but this should go to the testerror file