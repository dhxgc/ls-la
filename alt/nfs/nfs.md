### Сервер
---
```
apt-get install nfs-server
```

```
systemctl enable --now nfs
```

```
mkdir /home/share
```

`nano /etc/exports`:
```
/home/share 192.168.1.0/24(no_subtree_check,rw)
```

```
systemctl restart nfs.service
```

```
exportfs
```

### Клиент
---
```
mkdir /mnt/share
```

`nano /etc/fstab`:
```
192.168.1.1:/home  /mnt/nfs   nfs   intr,soft,nolock,_netdev,x-systemd.automount    0 0
```

```
systemctl daemon-reload
```

```
mount -a
```