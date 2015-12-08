#!/bin/bash
#assuming /mnt/isilon is used as the mountpoint on Harness Server
# first, connect to the first isilon node, and flush cache on array
echo "Purging L1 and L2 cache first";
ssh -i /mnt/isilon/fiotest/control/trusted.key 10.111.158.206 -fqno StrictHostKeyChecking=no "isi_for_array isi_flush";
# wait for cache flushing to finish, normally around 10 seconds is enough
# on larger clusters, sometimes up to few minutes should be used!
sleep 10;
echo "On OneFS 7.1.1 clusters and newer, running L3, purging L3 cache";
ssh -i /mnt/isilon/fiotest/control/trusted.key 10.63.208.64 -fqno StrictHostKeyChecking=no "isi_for_array isi_flush --l3-full";
sleep 10;
# the rest is similar to the other scripts
# first go through all lines in nfs_hosts.list
for i in $(cat /mnt/isilon/fiotest/control/nfs_hosts.list) ; do
# then split each line read in to an array by the pipe symbol
IFS='|' read -a pairs <<< "${i}";
# connect over ssh with the key and mount hosts, create directories etc. - has to be single line
# echo 3 > /proc/sys/vm/drop_caches free pagecache, dentries and inodes
# sync purges all buffers to disk
# pointing to fio job file that is one level above from control directory
ssh -i /mnt/isilon/fiotest/control/trusted.key ${pairs[0]} -fqno StrictHostKeyChecking=no "sync && echo 3 > /proc/sys/vm/drop_caches; FILENAME=\"/mnt/isilon/fiotest/${pairs[0]}\" fio --output=/mnt/isilon/fiotest/nfs_fioresult_1024k_randread_${pairs[0]}.txt /mnt/isilon/fiotest/fiojob_1024k_randread";
done
