#!/bin/bash
rm -rf alpine-tmp alpine-vm

docker build -t alpine-vm .
ID=$(docker run -it -d alpine-vm sh)
docker export $ID | docker import - alpine-vm-flat
docker save alpine-vm-flat > alpine.tar

mkdir -p alpine-tmp alpine-vm
mv alpine.tar alpine-tmp
cd alpine-tmp && tar -xvf alpine.tar
mv */layer.tar ../alpine-vm
echo "extracting layer.tar"
# Use gnu-tar
# https://github.com/docker/for-mac/issues/1578
cd ../alpine-vm && gtar -xf layer.tar
rm layer.tar
echo "creating /tmp/file.img"
find . | cpio -o -H newc > /tmp/file.img;
echo "compressing img"
cd /tmp && gzip file.img

