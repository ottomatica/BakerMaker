#!/bin/sh

HYPERKIT="hyperkit"

# Linux
INITRD="/tmp/file.img.gz"
KERNEL="kernel/vmlinuz-virt"

CMDLINE="earlyprintk=serial console=tty0 console=ttyS0 console=ttyAMA0"

MEM="-m 1G"
#SMP="-c 2"
#NET="-s 2:0,virtio-net"
#IMG_CD="-s 3,ahci-cd,/somepath/somefile.iso"
#IMG_HDD="-s 4,virtio-blk,/somepath/somefile.img"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"
ACPI="-A"
#UUID="-U deadbeef-dead-dead-dead-deaddeafbeef"

hyperkit $ACPI $MEM $SMP $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD $UUID -f kexec,$KERNEL,$INITRD,"$CMDLINE"
