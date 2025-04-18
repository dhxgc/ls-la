## Samba DC и BIND9_DLZ
> Очень кратенькое описание, того что проделал, именно в таком порядке
> Источник: [[sysahelper, dns + samba]]()
1. Начальные действия
```bash
hostnamectl hostname dc.domain.name
```

```bash
apt-get install task-samba-dc bind-utils bind -y
```

```bash
rm -f /etc/samba/smb.conf
rm -rf /var/lib/samba
rm -rf /var/cache/samba
mkdir -p /var/lib/samba/sysvol
```

2. Настройка BIND'а
```bash
echo 'KRB5RCACHETYPE="none"' >> /etc/sysconfig/bind
echo 'include "/var/lib/samba/bind-dns/named.conf";'
```

`/etc/bind/options.conf`:
```bind
/* !!!REQUIRED!!! */
recursion yes;
forwarders {
        8.8.8.8;
        8.8.4.4;
};
listen-on { 127.0.0.1; 192.168.122.102; };
allow-recursion { any; };
allow-query { any; };
allow-transfer { any; };
```
> На этом моменте после рестартов должен работать форвардер

3. Интеграция BIND'а с самбой
```bash
grep -q KRB5RCACHETYPE /etc/sysconfig/bind || echo 'KRB5RCACHETYPE="none"' >> /etc/sysconfig/bind
grep -q 'bind-dns' /etc/bind/named.conf || echo 'include "/var/lib/samba/bind-dns/named.conf";' >> /etc/bind/named.conf
```

`/etc/bind/options.conf`:
```bind
tkey-gssapi-keytab "/var/lib/samba/bind-dns/dns.keytab";
minimal-responses yes;

# In logging {}
category lame-servers {null;};
```

4. Развертывание домена
```bash
systemctl stop bind
samba-tool domain provision

systemctl enable --now samba
systemctl start bind

cp /var/lib/samba/private/krb5.conf /etc/krb5.conf : Yes
```

> Проверка
```bash
kinit administrator
```