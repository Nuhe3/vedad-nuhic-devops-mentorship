
#!/bin/bash
# You can start any number of background jobs at the same time from the 
# command line prompt:

./05-running-in-backgr.sh &

./06-ch16-test-running-bck.sh &

# Each time you start a new job, 
# the Linux system assigns it a new job number and PID. 
# You can see that all the scripts are running 
# using the ps command