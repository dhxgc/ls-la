> Источник - [[Документация]](https://help.mikrotik.com/docs/spaces/ROS/pages/8323193/Bonding#Bonding-Linkmonitoring)

### Простейший бонд на CHR:

1. На первом коммутаторе:
```routeros
/interface bonding add slaves=ether1,ether2 name=bond1
```

2. На втором коммутаторе:
```routeros
/interface bonding add slaves=ether1,ether2 name=bond1
```