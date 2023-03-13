#!/bin/bash
# testing STDERR messages
echo "This is an error" >&2
echo "This is normal output"

# cat script.sh
# to run the script ./script.sh
# there should be no difference