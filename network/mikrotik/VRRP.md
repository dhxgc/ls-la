> Ниже описана вариация для VLAN интерфейса (в RoaS), но работает аналогично с обычными интерфейсами

### Master:
```routeros
/interface vrrp
add interface=vlan10 name=vrrp10 vrid=10 priority=120 preemption-mode=yes

/ip address
add address=192.168.10.1/24 interface=vlan10
add address=192.168.10.254 interface=vrrp10  # Виртуальный IP
```

### Slave:
> В `Slave` стоит другой ___priority___!!
```routeros
/interface vrrp
add interface=vlan10 name=vrrp10 vrid=10 priority=100 preemption-mode=yes

/ip address
add address=192.168.10.2/24 interface=vlan10
add address=192.168.10.254 interface=vrrp10  # Виртуальный IP
```