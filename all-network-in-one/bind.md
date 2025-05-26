```
apt-get update && apt-get install bind bind-utils -y
```
---
`/var/lib/bind/etc/options.conf`:
```
options {
        directory "/var/cache/bind";
        
	recursion yes;
        forwarders {
                77.88.8.8;
                8.8.8.8;
        };

        listen-on { any; };
        listen-on-v6 { any; };
        allow-query { any; };
};
```
---
```
systemctl enable --now bind
```
---
`nano /etc/net/ifaces/ens5/resolv.conf`:
```
search au.team
nameserver 127.0.0.1
```
---
`nano /var/lib/bind/etc/local.conf`:
```
zone "au.team" IN {
        type master;
        file "/etc/bind/au-team.db";
};

zone "1.168.192.in-addr.arpa" IN {
        type master;
        file "/etc/bind/1.db";
};

zone "2.168.192.in-addr.arpa" IN {
        type master;
        file "/etc/bind/2.db";
};
```
---
```
cp /var/lib/bind/etc/zone/{localdomain,au.team.db}
```

```
chown named. /var/lib/bind/etc/zone/au-team.db
chmod 600 /var/lib/bind/etc/zone/au-team.db
```
---
Прямая зона:
```
$TTL 86400
@       IN  SOA     ns1.au.team. root.au.team. (
                    2024022001  ; Serial
                    3600        ; Refresh
                    1800        ; Retry
                    604800      ; Expire
                    86400 )     ; Minimum TTL

; Required
@           IN  NS      ns1.au.team.
@           IN  A       192.168.122.50
ns1         IN  A       192.168.122.50

; Optional

; A
dc          IN  A       192.168.122.50

; CNAME
www         IN  CNAME   @
site        IN  CNAME   dc.au.team

; For Mail Server - Required
@           IN        MX 10     mail
mail        IN        A         192.168.122.50
```
---
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
---
Обратная зона:
```
$TTL 86400
@       IN  SOA     ns1.au.team. root.au.team. (
                   2024022001  ; Serial
                   3600        ; Refresh
                   1800        ; Retry
                   604800      ; Expire
                   86400 )

; Required
@       IN  NS      ns1.au.team.

; Optional
50      IN  PTR     ns1.au.team.
50      IN  PTR     mail.au.team.
50      IN  PTR     dc.au.team.
```

```
named-checkconf -z
```

```
systemctl restart bind
```
---
Проверять:
```
named-checkconf -z
host
dig
nslookup
```
