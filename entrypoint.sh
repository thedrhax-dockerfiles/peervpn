#!/bin/sh

if [ ! "$VPN_KEY" ]; then
    echo "WARNING: VPN_KEY is not provided! Using default key 'peervpn'"
fi

if [ ! "$VPN_IP" ]; then
    echo "ERROR: Variable VPN_IP is not set"
    exit 1
fi

cat >> /peervpn.conf <<EOF
networkname ${VPN_NAME:-peervpn}
psk ${VPN_KEY:-peervpn}
enabletunneling yes
enablerelay no
port ${VPN_PORT:-7000}

interface ${VPN_INTERFACE:-vpn0}
ifconfig4 ${VPN_IP}/${VPN_CIDR:-24}

enableprivdrop yes
user nobody
group nogroup

`[ "$VPN_PEERS" ] && cat <<EOF
initpeers $(echo $VPN_PEERS | sed 's/:/ /g')
`
EOF

exec "$@"
