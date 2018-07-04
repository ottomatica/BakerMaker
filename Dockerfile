FROM alpine:latest AS build
RUN mkdir -p /lib/apk/db /run
RUN apk add --no-cache --initdb openrc

FROM alpine:latest AS install
# the public key that is authorized to connect to this instance.
ARG SSHPUBKEY

USER root 
RUN mkdir -p /lib/apk/db /run

RUN apk add --no-cache --initdb alpine-baselayout apk-tools busybox ca-certificates musl tini util-linux \
    openssh openssh-client \
    #bash iproute2 iptables ebtables ipvsadm bridge-utils \
    dhcpcd 
    #openrc


RUN mkdir -p /etc/ssl/certs
RUN mkdir -p /lib/firmware
RUN mkdir -p /lib/mdev
RUN mkdir -p /lib/modules
RUN mkdir -p /lib/rc

# don't want all the /etc stuff from openrc -- only tools
# https://pkgs.alpinelinux.org/contents?repo=main&page=2&arch=x86_64&branch=v3.8&name=openrc
COPY --from=build /lib/ /lib/
COPY --from=build /bin /bin
COPY --from=build /sbin /sbin

COPY --from=build /etc/ /etc/

# Deleted cached packages
RUN rm -rf /var/cache/apk/*

# remove some config relying on openrc
#RUN rm -rf /etc/init.d/dhcpcd 
# /etc/init.d/sshd

COPY files/init /init
COPY files/bin /bin/
COPY files/etc/ /etc/
COPY files/usr/ /usr/

# Set an ssh key
RUN mkdir -p /etc/ssh /root/.ssh && chmod 0700 /root/.ssh
RUN echo $SSHPUBKEY > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys \
    && chown -R root:root /root/.ssh/

