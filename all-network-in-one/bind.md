```
apt-get update && apt-get install bind bind-utils -y
```
OPTIONS

```
systemctl enable --now bind
```

`nano /etc/net/ifaces/ens5/resolv.conf`:
```
search au.team
nameserver 127.0.0.1
```

```
cp /var/lib/bind/etc/zone/{localdomain,champ.db}
```

```
chown named. /var/lib/bind/etc/zone/au-team.db
chmod 600 /var/lib/bind/etc/zone/au-team.db
```

Прямая зона:
```
$TTL 86400
@       IN  SOA     ns1.atom25.local. admin.atom25.local. (
                    2024022001  ; Serial
                    3600        ; Refresh
                    1800        ; Retry
                    604800      ; Expire
                    86400 )     ; Minimum TTL

; Required
@           IN  NS      ns1.atom25.local.
@           IN  A       192.168.122.50
ns1         IN  A       192.168.122.50

; Optional

; A
dc          IN  A       192.168.122.50

; CNAME
www         IN  CNAME   @
site        IN  CNAME   dc.atom25.local

; For Mail Server - Required
@           IN        MX 10     mail
mail        IN        A         192.168.122.50
```

```
named-checkconf -z
```

```
systemctl restart bind
```

```
cp /var/lib/bind/etc/zone/{127.in-addr.arpa,1.db}
cp /var/lib/bind/etc/zone/{127.in-addr.arpa,2.db}
```

```
chown named. /var/lib/bind/etc/zone/{1,2}.db
chmod 600 /var/lib/bind/etc/zone/{1,2}.db
```

Обратная зона:
```
$TTL 86400
@       IN  SOA     ns1.atom25.local. admin.atom25.local. (
                   2024022001  ; Serial
                   3600        ; Refresh
                   1800        ; Retry
                   604800      ; Expire
                   86400 )

; Required
@       IN  NS      ns1.atom25.local.

; Optional
50      IN  PTR     ns1.atom25.local
50      IN  PTR     mail.atom25.local.
50      IN  PTR     dc.atom25.local
```

```
named-checkconf -z
```

```
systemctl restart bind
```

Проверять:
```
named-checkconf -z
host
dig
nslookup
```
