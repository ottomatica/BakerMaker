FROM alpine:latest AS build

USER root 
RUN mkdir -p /lib/apk/db /run

RUN apk add --no-cache --initdb alpine-baselayout apk-tools busybox ca-certificates musl tini util-linux
# Add /etc/ssl/certs so it can be bind-mounted into metadata package
RUN mkdir -p /etc/ssl/certs
RUN mkdir -p /lib/firmware
RUN mkdir -p /lib/mdev

# Deleted cached packages
RUN rm -rf /var/cache/apk/*

COPY init /init
COPY files/bin /bin/
COPY files/etc/ /etc/
COPY files/usr/ /usr/