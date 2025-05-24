#!/bin/bash

# Save rules:
# iptables-save > /etc/sysconfig/iptables

OUT_IFACE="ens3"
INTERNAL_NETWORKS=(
  "192.168.10.0/24"
  "10.0.0.0/24"
)

if [[ "$1" == "-c" ]]; then
  echo "Cleaning MASQUERADE rules from POSTROUTING..."
  iptables -t nat -S POSTROUTING | grep MASQUERADE | while read -r rule; do
    echo "Deleting rule: $rule"
    iptables -t nat ${rule/-A/-D}
  done
  echo "Cleanup done."
  exit 0
fi

for NET in "${INTERNAL_NETWORKS[@]}"; do
  echo "Adding MASQUERADE for $NET via $OUT_IFACE"
  iptables -t nat -A POSTROUTING -s "$NET" -o "$OUT_IFACE" -j MASQUERADE
done

echo "MASQUERADE rules successfully added."
