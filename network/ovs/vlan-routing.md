# Маршрутизация между VLAN в OVSе
# ___ЧИТАЙ ВНИМАТЕЛЬНО___


> Источник: https://sysahelper.ru/mod/page/view.php?id=464 и https://sysahelper.ru/mod/page/view.php?id=242
> 
> Если что-то не работает, то посмотреть на `options` (2 шаг), он изменен

#### Транки, доступ, все дела - должно быть готово

<br>

---

<br>

#### 1. Добавить интерфейсы, кинуть теги:
> Аналогично для каждого VLANа
```bash
ovs-vsctl add-port br0 vlan10 -- set interface vlan10 type=internal
ovs-vsctl set port vlan10 tag=10
```

#### 2. `options` для VLAN интерфейсов, IP и прочее без изменений:
> Аналогично для каждого VLANа
```
# /etc/net/ifaces/vlan10/options
TYPE=eth
BOOTPROTO=static
BRIDGE=br0
```

#### Включить маршрутизацию:
```bash
# /etc/net/sysctl.conf -> net.ipv4.ip_forward = 1
sysctl -p
systemctl restart network
systemctl openvswitch
```