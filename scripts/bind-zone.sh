#!/bin/bash

# NOT TESTED

DOMAIN="$1"
SERVER_IP="$2"

if [[ -z $1 || -z $2 ]]; then
    echo Usage: $0 domain.com 10.0.0.1
    exit 1
fi

ZONETEMPLATE="\$TTL 86400
@	IN	SOA	ns1.${DOMAIN}. admin.${DOMAIN}. (
			2024022001  ; Serial
			3600        ; Refresh
			1800        ; Retry
			604800      ; Expire
			86400 )     ; Minimum TTL
; Required
@	IN	NS	ns1.${DOMAIN}.
@	IN	A	${SERVER_IP}
ns1	IN	A	${SERVER_IP}
"

echo -e "${ZONETEMPLATE}" > db."${DOMAIN}"
