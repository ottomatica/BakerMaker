#!/bin/bash

mkdir -p ~/Library/Baker/run

pid=`cat ~/Library/Baker/run/bakerformac-vpnkit.pid`

#mkfifo /tmp/vsocket

if [ ! `ps -a | grep $pid | grep vpnkit.exe` ]; then
    echo "Starting vpnkit"
    vendor/vpnkit.exe --host-names baker.for.mac.localhost --debug --ethernet /tmp/bakerformac.sock --port /tmp/bakerformac.port.socket --vsock-path /tmp/connect  >~/Library/Baker/run/bakerformac-vpnkit.log 2>&1 &
    echo $! > ~/Library/Baker/run/bakerformac-vpnkit.pid
fi

# com.docker.vpnkit --ethernet fd:3 --port fd:4 --introspection fd:5 --diagnostics fd:6 --vsock-path /Users/andrew/Library/Containers/com.docker.docker/Data/connect --host-names docker.for.mac.localhost,docker.for.mac.host.internal --gateway-names docker.for.mac.gateway.internal,docker.for.mac.http.internal --listen-backlog 32 --mtu 1500 --allowed-bind-addresses 0.0.0.0 --http /Users/andrew/Library/Group Containers/group.com.docker/http_proxy.json --dhcp /Users/andrew/Library/Group Containers/group.com.docker/dhcp.json --port-max-idle-time 300 --max-connections 2000 --gateway-ip 192.168.65.1 --host-ip 192.168.65.2 --lowest-ip 192.168.65.3 --highest-ip 192.168.65.254 --log-destination asl


USEVPNKIT=true ./hyperkitrun.sh
