## Возможные проблемы

### Запуск в `podman`, ALT:
1. Если не указывать конкретный IP в портах - будет ошибка:
```logs
Error response from daemon: cannot listen on the TCP port: listen tcp4 :53: bind: address already in use
```
> Как я понимаю, потому что подман где-то там у себя юзает 53 порт, хоть оно и не отображается.

___Фикс:___
```yml
ports:
 - 192.168.122.52:53:53/tcp
```

2. Внимательно перепроверять ВСЕ ТОЧКИ!!! ВСЕ ЧТО МЕНЯЛОСЬ!!!

---

## Примеры зон:

### Прямая:
```bind
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

; Files with other records
$INCLUDE /etc/bind/db.atom25.local.A
$INCLUDE /etc/bind/db.atom25.local.CNAME

; All queries to subdomains on one IP
*.sites.atom25.local.     IN  A   192.168.122.103
```

### Обратная:
```bind
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
50      IN  PTR     nc1.atom25.local
50      IN  PTR     mail.atom25.local.
50      IN  PTR     dc.atom25.local
```