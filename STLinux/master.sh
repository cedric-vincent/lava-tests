#!/bin/bash

lava-wait lava_ms_slave_data
kernel_url=$(grep 'kernel' /tmp/lava_multi_node_cache.txt | cut -d '=' -f2)
nfs_ip=$(grep 'nfs_server_ip' /tmp/lava_multi_node_cache.txt | cut -d '=' -f2)
nfs_rootfs=$(grep 'nfs_rootfs' /tmp/lava_multi_node_cache.txt | cut -d '=' -f2)
stmc_ip=$(grep 'stmc_ip' /tmp/lava_multi_node_cache.txt | cut -d '=' -f2)
wget $kernel_url -O vmlinux

echo "Setup the STMC at $stmc_ip"
python STLinux/stmc2_check.py /opt/STM/STLinux-2.4/host/stmc/bin/stmcconfig $stmc_ip /bin/true

lava-send lava_ms_ready
lava-wait lava_ms_boot
echo 'Delivering trough STMC'

echo "PATH=$PATH:/opt/STM/STLinux-2.4/devkit/sh4/bin st40load_gdb -t $stmc_ip:hdk7108stx7108:host,seuc=1,boardrev=3,overclk=0,silent=0,verbose=1 -r --ex 'set linux-awareness enabled on' --ex 'set pagination off' -b vmlinux -- console=ttyAS1,115200 root=/dev/nfs nfsroot=$nfs_ip:$nfs_rootfs,nfsvers=3,rsize=4096,wsize=8192,tcp nwhwconf=device:eth0,hwaddr:00:80:e1:12:6c:af ip=10.129.186.25::10.129.186.254:255.255.255.0:bd7108_4:eth0:off bpa2parts=bigphysarea:64M::,modules:2M::"
PATH=$PATH:/opt/STM/STLinux-2.4/devkit/sh4/bin st40load_gdb -t $stmc_ip:hdk7108stx7108:host,seuc=1,boardrev=3,overclk=0,silent=0,verbose=1 -r --ex 'set linux-awareness enabled on' --ex 'set pagination off' -b vmlinux -- console=ttyAS1,115200 root=/dev/nfs nfsroot=$nfs_ip:$nfs_rootfs,nfsvers=3,rsize=4096,wsize=8192,tcp nwhwconf=device:eth0,hwaddr:00:80:e1:12:6c:af ip=10.129.186.25::10.129.186.254:255.255.255.0:bd7108_4:eth0:off bpa2parts=bigphysarea:64M::,modules:2M::
