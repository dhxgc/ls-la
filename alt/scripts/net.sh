#!/bin/bash

### === VARs ===

USE_DHCP=false # If true = parameters for static ip will be skipped
INTERFACE="ens3"
STATIC_IP="192.168.122.13/24"
GATEWAY="192.168.122.1"
DNS="8.8.8.8"

### === PATHs ===

BASE="/etc/net/ifaces/$INTERFACE"

mkdir -p "$BASE"

if $USE_DHCP; then
    echo -n > "$BASE/ipv4route"
    echo -n > "$BASE/ipv4address"
    cat <<EOF > "$BASE/options"
BOOTPROTO=dhcp
TYPE=eth
NM_CONTROLLED=no
DISABLED=no
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=dhcp4
CONFIG_IPV4=yes
SYSTEMD_CONTROLLED=no
EOF

else
    echo "$STATIC_IP" > "$BASE/ipv4address"
    echo "default via $GATEWAY" > "$BASE/ipv4route"
    cat <<EOF > "$BASE/resolv.conf"
nameserver $DNS
EOF

    cat <<EOF > "$BASE/options"
BOOTPROTO=static
TYPE=eth
NM_CONTROLLED=no
DISABLED=no
CONFIG_WIRELESS=no
SYSTEMD_BOOTPROTO=static
CONFIG_IPV4=yes
SYSTEMD_CONTROLLED=no
EOF
fi

echo "Net completed for: $INTERFACE"