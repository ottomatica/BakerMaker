FROM linuxkit/alpine:daed76b8f1d28cdeeee215a95b9671c682a405dc AS build2

RUN apk add --no-cache go musl-dev git build-base
ENV GOPATH=/go PATH=$PATH:/go/bin 
ENV COMMIT=db7b7b0f8147f29360d69dc81af9e2877647f0de

RUN git clone https://github.com/moby/vpnkit.git /go/src/github.com/moby/vpnkit && \
    cd /go/src/github.com/moby/vpnkit && \
    git checkout $COMMIT && \
    cd go && \
    make build/vpnkit-iptables-wrapper.linux build/vpnkit-expose-port.linux build/vpnkit-forwarder.linux

FROM alpine:latest AS build
RUN mkdir -p /lib/apk/db /run
RUN apk add --no-cache --initdb openrc

FROM alpine:latest AS kernel
RUN mkdir -p /lib/apk/db /run
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.8/main" >> /etc/apk/repositories
RUN apk add --no-cache --initdb linux-virt

FROM alpine:latest AS install
# the public key that is authorized to connect to this instance.
ARG SSHPUBKEY

USER root 
RUN mkdir -p /lib/apk/db /run

RUN rm -rf /var/cache/apk && mkdir /var/cache/apk
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.8/community" >> /etc/apk/repositories

# Get some modules for virtio
#COPY --from=kernel /lib/modules/4.14.52-0-virt/kernel/drivers/virtio/virtio.ko /lib/modules/4.14.52-0-virt/kernel/drivers/virtio/virtio.ko
#COPY --from=kernel /lib/modules/4.14.52-0-virt/kernel/drivers/net/virtio_net.ko /lib/modules/4.14.52-0-virt/kernel/drivers/net/virtio_net.ko
COPY --from=kernel /lib/modules /lib/modules

RUN apk add --update --no-cache --initdb alpine-baselayout apk-tools busybox ca-certificates musl tini util-linux \
    openssh openssh-client rng-tools ansible \
    #bash iproute2 iptables ebtables ipvsadm bridge-utils \
    dhcpcd virtualbox-guest-additions virtualbox-guest-modules-virt
    #openrc

RUN rm -rf /var/cache/apk && mkdir -p /var/cache/apk

RUN mkdir -p /etc/ssl/certs
RUN mkdir -p /lib/firmware
RUN mkdir -p /lib/mdev
RUN mkdir -p /lib/rc

COPY --from=build2 /go/src/github.com/moby/vpnkit/go/build/vpnkit-iptables-wrapper.linux /usr/bin/vpnkit-iptables-wrapper
COPY --from=build2 /go/src/github.com/moby/vpnkit/go/build/vpnkit-expose-port.linux /usr/bin/vpnkit-expose-port
COPY --from=build2 /go/src/github.com/moby/vpnkit/go/build/vpnkit-forwarder.linux /usr/bin/vpnkit-forwarder


# don't want all the /etc stuff from openrc -- only tools
# https://pkgs.alpinelinux.org/contents?repo=main&page=2&arch=x86_64&branch=v3.8&name=openrc
COPY --from=build /lib/ /lib/
COPY --from=build /bin /bin
COPY --from=build /sbin /sbin

COPY --from=build /etc/ /etc/

# Deleted cached packages
RUN rm -rf /var/cache/apk/* && mkdir -p /var/cache/apk

# remove some config relying on openrc
#RUN rm -rf /etc/init.d/dhcpcd 
# /etc/init.d/sshd

COPY files/init /init
COPY files/bin /bin/
COPY files/etc/ /etc/
COPY files/usr/ /usr/

# Prepare data directory for mount
# TODO modify/update /etc/fstab to handle v9 for hyperkit version.
RUN mkdir -p /data

# Set an ssh key
RUN mkdir -p /etc/ssh /root/.ssh && chmod 0700 /root/.ssh
RUN echo $SSHPUBKEY > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

#chown -R root:root /root/.ssh/
