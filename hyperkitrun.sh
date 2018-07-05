#!/bin/sh

HYPERKIT="hyperkit"

# Linux
INITRD="/tmp/file.img.gz"
#KERNEL="kernel/vmlinuz-virt"
#KERNEL="kernel/vmlinuz-vanilla"
KERNEL="kernel/sshd-kernel"

CMDLINE="modules=virtio_net console=tty0 console=ttyS0 console=ttyAMA0"

MEM="-m 1G"
#SMP="-c 2"
NET="-s 1:0,virtio-net"
if $USEVPNKIT; then
    echo "using vpnkit for network"
    NET="-s 1:0,virtio-vpnkit,path=/tmp/bakerformac.sock"
fi

#IMG_CD="-s 3,ahci-cd,/somepath/somefile.iso"
#IMG_HDD="-s 4,virtio-blk,/somepath/somefile.img"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"
ACPI="-A"
#UUID="-U deadbeef-dead-dead-dead-deaddeafbeef"

hyperkit $ACPI $MEM $SMP $PCI_DEV $LPC_DEV $NET $IMG_CD $IMG_HDD $UUID -f kexec,$KERNEL,$INITRD,"$CMDLINE"
