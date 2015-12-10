#!/bin/bash
# first, connect to the first isilon node, and flush cache on array
echo "Purging L1 and L2 cache first";
#ssh -i /mnt/isilon/fiotest/control/trusted.key IP.OF.ISILON.NODE -fqno StrictHostKeyChecking=no "isi_for_array isi_flush";
# wait for cache flushing to finish, normally around 10 seconds is enough
sleep 10;
#the L3 cache purge is not recommended as all metadata accelerated by SSDs is going. but, maybe...
#echo "On OneFS 7.1.1 clusters and newer, running L3, purging L3 cache";
#ssh -i /mnt/isilon/fiotest/control/trusted.key 10.63.208.64 -fqno StrictHostKeyChecking=no "isi_for_array isi_flush --l3-full";
#sleep 10;
# the rest is similar to the other scripts
# first go through all lines in smb_hosts.list
for i in $(cat /mnt/isilon/fiotest/control/smb_hosts.list) ; do
# then split each line read in to an array by the pipe symbol
IFS='|' read -a pairs <<< "${i}";
# connect over ssh with the key and mount hosts, create directories etc. - has to be single line
# pointing to fio job file that is one level above from control directory
# yes it is a nightmare of slashes
ssh -i /mnt/isilon/fiotest/control/trusted.key ${pairs[0]} -fqno StrictHostKeyChecking=no "export FILENAME=\\\\\\\\${pairs[1]}\\\\fiotest\\\\${pairs[0]} ; /cygdrive/c/fio/fio.exe --output=\\\\\\\\${pairs[1]}\\\\fiotest\\\\smb_fioresult_1024k_seqwrite_${pairs[0]}.txt \\\\\\\\${pairs[1]}\\\\fiotest\\\\fiojob_1024k_seqwrite";
done
