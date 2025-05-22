# VLAN'ы и всякое прочее

Комментарии:
> Предварительно VLAN'ы надо на коммутаторе создать

### Диагностика

Посмотреть VLANы и порты:
> tagged - транки
>
> untagged - access 
>
> `gi1/0/3` и `po1` - транки, `VLAN1` для них - `native vlan`
```cisco
SW3(config-if-gi)# do show vlans
VID    Name                   Tagged                   Untagged
----   --------------------   ----------------------   ----------------------
1      default                                         gi1/0/3, po1
10     --                     gi1/0/3, po1             gi1/0/5
20     --                     gi1/0/3, po1
30     --                     gi1/0/3, po1
```

---

### Настройка

Порт в access:
```cisco
switchport mode access
switchport access vlan 10
```

Порт в trunk:
```cisco
switchport mode trunk
switchport trunk allowed vlan add 10,20,30
```