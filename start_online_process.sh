#!/bin/bash
# This files lives somewhere on the FS-computer and is called from the procedure 'checkfb'.
# This script takes the experiment name from the field system as input and checks
# if it is related to a FRB/pulsar experiment (starts with 'p') and that it is not a VLBI experiment (second character is not 'r')
# If so, then it checks the name of the current scan and submits a processing job to ebur; i.e. run online_process.sh on ebur.

# get the experiment name from the FS
ExpName=$(lognm)

# The LogDir refers to a directory on the processing machine. The output from the processing pipeline is written
# to a file in that directory name <ScanName>.log
LogDir=/home/oper/frb_processing/logs/

# check if naming convention for single dish pulsar/FRB experiment is fulfilled
if [ ${ExpName:0:1} == "p" ]; then
    if [ ${ExpName:1:1} != "r" ]; then
        NewScan=$(inject_snap -w "mk5=scan_set?") # Determine the scan name
        ScanName=$(cut -f3 -d":" <<< $NewScan | sed 's/ //g') # the sed removes white space
        ssh oper@ebur "/home/cecilia/Documents/frb-baseband/online_process.sh 1&> ${LogDir}/${ScanName}.log"
    fi
fi
