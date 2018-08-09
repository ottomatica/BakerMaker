ISO=~/Downloads/alpine-virt-3.8.0-x86_64.iso
hdiutil attach -nomount $ISO
DISK=/dev/disk2
mkdir -p alpine-iso/
FS_MOUNTOPTIONS="uid=1000,gid=1000" mount -t cd9660 $DISK alpine-iso
#cp -a alpine-iso/. baker-mount/
cp -a alpine-iso/. baker-mount
umount alpine-iso

# make items writable
chmod +w baker-mount/boot/syslinux/isolinux.bin
chmod +w baker-mount/boot/initramfs-virt
chmod +w baker-mount/boot/vmlinuz-virt

# update
cp /tmp/file.img.gz baker-mount/boot/initramfs-virt
#cp kernel/sshd-kernel baker-mount/boot/vmlinuz-virt

# Needs `brew install cdrtools`
mkisofs -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table   -V baker -o baker.iso -J -R baker-mount/