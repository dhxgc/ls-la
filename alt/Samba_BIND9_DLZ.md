## Samba DC и BIND9_DLZ

hostnamectl hostname dc.domain.name

apt-get install task-samba-dc bind-utils bind -y

rm -f /etc/samba/smb.conf
rm -rf /var/lib/samba
rm -rf /var/cache/samba
mkdir -p /var/lib/samba/sysvol

echo 'KRB5RCACHETYPE="none"' >> /etc/sysconfig/bind
echo 'include "/var/lib/samba/bind-dns/named.conf";'

/etc/bind/options.conf:
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


grep -q KRB5RCACHETYPE /etc/sysconfig/bind || echo 'KRB5RCACHETYPE="none"' >> /etc/sysconfig/bind
grep -q 'bind-dns' /etc/bind/named.conf || echo 'include "/var/lib/samba/bind-dns/named.conf";' >> /etc/bind/named.conf

/etc/bind/options.conf:
```bind
tkey-gssapi-keytab "/var/lib/samba/bind-dns/dns.keytab";
minimal-responses yes;

# In logging {}
category lame-servers {null;};
```

systemctl stop bind
samba-tool domain provision

systemctl enable --now samba
systemctl start bind

cp /var/lib/samba/private/krb5.conf /etc/krb5.conf : Yes

kinit administrator