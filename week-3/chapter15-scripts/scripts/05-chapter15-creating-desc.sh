#!/bin/bash
# using an alternative file descriptor
exec 3>test13out
echo "This should display on the monitor"
echo "and this should be stored in the file" >&3
echo "Then this should be back on the monitor"

# Output
# $ ./05-chapter15-creating-desc.sh
# This should display on the monitor
# Then this should be back on the monitor
# $ cat test13out
# and this should be stored in the file