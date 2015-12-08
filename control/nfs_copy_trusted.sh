#!/bin/bash
# apart from running this script, copy trusted file to the Isilon node
# of choice that would be used to clear cache when running the fio job
# by the same command as below
#
# the rest of the file is similar to most of the other scripts
#
# first go through all lines in hosts.list
for i in $(cat /mnt/isilon/fiotest/control/nfs_hosts.list) ; do
# then split each line read in to an array by the pipe symbol
IFS='|' read -a pairs <<< "${i}";
# do the ssh-copy-id for putting the certificate to remote host
ssh-copy-id -i /mnt/isilon/fiotest/control/trusted.key.pub ${pairs[0]}
done
