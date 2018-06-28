# BakerForMac

Experiments with HyperKit and LinuxKit



## Create image


```
docker run -it -d image sh
docker export <CONTAINER ID> | docker import - got_it
docker save got_it > extracted_fs.tar
```

```
cd extracted_fs
find . | cpio -o -H newc > /tmp/file.img
cd ..
mv /tmp/file.img extracted_fs.img
```

merge
```
rsync -avhu --progress source dest
```

## Resources


#### Concepts

* https://padgeblog.com/2014/12/02/containers-dont-really-boot/

#### Hyperkit

* https://github.com/linuxkit/linuxkit/blob/master/docs/platform-hyperkit.md


#### Docker/Layers

* https://tuhrig.de/flatten-a-docker-container-or-image/

#### cpio/img

* https://www.thegeekstuff.com/2010/08/cpio-utility/
* https://unix.stackexchange.com/questions/298254/how-to-create-ascii-cpio-archive-svr4-with-no-crc
* https://www.ibm.com/developerworks/community/blogs/mhhaque/entry/anatomy_of_the_initrd_and_vmlinuz?lang=en

#### Init

* https://www.centos.org/docs/5/html/5.1/Installation_Guide/s2-boot-init-shutdown-init.html
