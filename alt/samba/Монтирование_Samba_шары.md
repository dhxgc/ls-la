## Samba, монтирование на клиенте
> Источник: [[Wiki]](https://www.altlinux.org/%D0%9E%D0%B1%D1%89%D0%B8%D0%B5_%D0%BF%D0%B0%D0%BF%D0%BA%D0%B8#%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D0%B0)

#### С кредами сразу в команде:
> Остальные варики указаны в источнике, хватило этого
```bash
mount -t cifs "//192.168.122.102/Group 1" /mnt/group1/ -o users,username=g1user1,password="P@ssw0rd"
```

---

#### Через `/etc/fstab`:
> __ВАЖНО__: Если в названии шары имеются пробелы, то вместо него пишется `\040`. В примере шара названа `//dc/Group 1`
```fstab
//dc.local.gns.domain/Group\0401	/mnt/group1	cifs uid=0,credentials=/etc/fstab.creds,iocharset=utf8,noperm 0 0
```

Креды надо вставить в `/etc/fstab.creds`:
```
user=g1user1
password=P@ssw0rd
domain=local.gns.domain
```