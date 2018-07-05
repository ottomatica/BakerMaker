#!/bin/bash

mkdir -p ~/Library/Baker/run

pid=`cat ~/Library/Baker/runbakerformac-vpnkit.pid`

if [ ! -e /proc/$pid -a /proc/$pid/exe ]; then
    echo "Starting vpnkit"
    vendor/vpnkit.exe --ethernet /tmp/bakerformac.sock >~/Library/Baker/run/bakerformac-vpnkit.log 2>&1 &
    echo $! > ~/Library/Baker/run/bakerformac-vpnkit.pid

fi

USEVPNKIT=true ./hyperkitrun.sh
