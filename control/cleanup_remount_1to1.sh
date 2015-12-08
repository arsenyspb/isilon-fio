#!/bin/bash
# assuming /mnt/isilon is used as the mountpoint on Harness Server
# first go through all lines in hosts.list
for i in $(cat /mnt/isilon/fiotest/control/nfs_hosts.list) ; do
# then split each line read in to an array by the pipe symbol
IFS='|' read -a pairs <<< "${i}";
# show back the mapping
echo "Client host: ${pairs[0]}  Isilon node: ${pairs[1]}";
# connect over ssh with the key and mount hosts, create directories etc. - has to be single line
ssh -i /mnt/isilon/fiotest/control/trusted.key ${pairs[0]} -fqno StrictHostKeyChecking=no "rm -rf /mnt/isilon/fiotest/${pairs[0]}; sleep 1; umount -fl /mnt/isilon; sleep 7; mkdir /mnt/isilon;  sleep 5; mount -o wsize=1048576,rsize=1048576 ${pairs[1]}:/ifs/data/ /mnt/isilon/; sleep 7; mkdir /mnt/isilon/fiotest/${pairs[0]}";
# erase the array pair
unset pairs ;
# go for the next line in nfs_hosts.list;
done
