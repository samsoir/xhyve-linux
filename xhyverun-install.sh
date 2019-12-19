#!/bin/sh

KERNEL="linux"
INITRD="initrd.gz"
CMDLINE="earlyprintk=serial console=ttyS0"

MEM="-m 1G"
#SMP="-c 2"
NET="-s 2:0,virtio-net"
IMG_CD="-s 3,ahci-cd,mini.iso"
IMG_HDD="-s 4,virtio-blk,hdd130gb.img"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"
ACPI="-A"
UUID="-U DCF8D785-A15F-4540-9917-952204C9F465"

xhyve $ACPI $MEM $SMP $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD $UUID \
      -f kexec,$KERNEL,$INITRD,"$CMDLINE"
