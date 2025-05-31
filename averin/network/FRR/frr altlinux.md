### Базовая настройка
---
Хостнеймы:
```
hostnamectl set-hostname hq-rtr.au-team.irpo
```
Проверить:
```
hostname -f
```

### Пользователи
---
1. Создать с айди:
```
adduser --uid 1010 sshuser
```

2. Разрешаем использовать sudo:
```
usermod -aG wheel sshuser
```

3. Добавляем возможность sudo без пароля:
```
echo "sshuser ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
```

### SSH
---
1. `nano /etc/openssh/sshd_config`:
```
Port 2025
AllowUsers sshuser
MaxAuthTries 2
Banner /etc/openssh/banner
```

2. Баннер:
```
echo "Authorized access only" > /etc/openssh/banner
```

3. Рестарт:
```
systemctl restart sshd
```

### IP-адреса
---
#### Конфиг-файлы

```
su -
mkdir /etc/net/ifaces/ens*/
cp /etc/net/ifaces/ens5/options /etc/net/ifaces/ens6/options
```

#### Адресация

`nano /etc/net/ifaces/ens6/options`:
```
BOOTPROTO=static
SYSEMD_BOOTPROTO=static
```

`nano /etc/net/ifaces/ens6/ipv4address`:
```
192.168.1.10/24
```

#### Шлюз по умолчанию

`nano /etc/net/ifaces/ens6/ipv4route`:
```
default via 192.168.1.1
```

#### DNS

`nano /etc/net/ifaces/ens6/resolv.conf`:
```

```
### RoaS (подинтерфейсы)
---
1. Создаем папку:
```
mkdir /etc/net/ifaces/ens5.100
```

2. `nano /etc/net/ifaces/ens5.100/options`:
```
TYPE=vlan
HOST=ens5
VID=100
BOOTPROTO=static
```

3. ipv4address + ipv4route + resolv.conf

### OVS-порты
---
```
mkdir /etc/net/ifaces/vlan100
```

```
cat <<EOF > /etc/net/ifaces/vlan100/options
  TYPE=ovsport
  BRIDGE=HQ-SW
  VID=100
  BOOTPROTO=static
  CONFIG_IPV4=yes
EOF
```

```
echo "192.168.100.1/26" > /etc/net/ifaces/vlan100/ipv4address
```

```
mkdir /etc/net/ifaces/HQ-SW
```

```
echo "TYPE=ovsbr " > /etc/net/ifaces/HQ-SW/options
```

```
systemctl enable --now openvswitch
```

```
modprobe 8021q
```

```
echo "8021q" | tee -a /etc/modules
```

### forwarding
---
`nano /etc/net/sysctl.conf`:
```
net.ipv4.ip_forward = 1
```

### NAT
---
1. Правило:
```
iptables –t nat –A POSTROUTING –o enp0s3 –j MASQUERADE
```

2. Сохраняем:
```
iptables-save >> /etc/sysconfig/iptables
```

3. Автозагрузка:
```
systemctl enable --now iptables
```


### GRE
---
```
mkdir /etc/net/ifaces/gre1
```

`nano /etc/net/ifaces/gre1/options`:
```
TYPE=iptun
TUNTYPE=gre
TUNLOCAL=192.168.1.2
TUNREMOTE=192.168.2.2
TUNOPTIONS='ttl 16'
HOST=ens6
```

```
echo "10.0.10.1/30" > /etc/net/ifaces/gre1/ipv4address
```

```
systemctl restart network
```

```
modprobe gre
```

```
echo "gre" | tee -a /etc/modules
```

### IPSEC ???
---


### OSPF
---
**У соседей обязательно должны совпадать mtu на туннельных интерфейсах.**

#### Базовая настройка

```
apt-get install -y frr
```

`nano /etc/frr/daemons`:
```
ospfd=yes
```

```
systemctl restart frr
```

```
systemctl enable --now frr
```

`nano /etc/frr/frr.conf`:
```
ip router-id 2.2.2.2

router ospf
	passive-interface default
	network 10.0.10.0/30 area 0
	network 172.16.200.0/24 area 0
	exit
	
interface gre1
	no ip ospf passive
	exit
```

#### Аутентификация

```
interface gre1
	ip ospf authentication message-digest
	ip ospf message-digest-key 1 md5 P@ssw0rd
	exit
```

#### Смена типа подключения

```
interface gre1
	ip ospf network point-to-point
	exit
```

### VRRP + RoaS
---

### DHCP
---
```
apt-get install -y dhcp-server
```

