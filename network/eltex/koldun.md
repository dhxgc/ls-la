### Диагностика/проверка
---
```
show candidate-config
show interfaces status
show ip interfaces
show ipv6 interfaces
show ip route
show ipv6 route
show ip dhcp pool <name>
show vlans
show ip ospf neighbors
show ip route ospf
show ip ospf 1 database
show ip ospf interface
```

### Базовая настройка
---
Первый вход:
```
login: admin
password: password
```

1. Требуется поменять пароль по умолчанию и подтвердить изменения:
```
password P@ssw0rd
commit
confirm
```

2. Открыть режим конфигурации:
```
configure terminal
```

3. Установить хостнейм:
```
hostname vESR-R1
```

4. Баннер до входа в систему:
```
banner login "123"
```
Либо после входа в систему:
```
banner exec "456"
```

5. Новый пользователь с админскими правами:
```
username superadmin
	password P@ssw0rd
	privilege 15
	exit
```

### IP-адреса (v4 и v6)
---
```
interface gigabitethernet 1/0/2
	description "123"
	ip firewall disable
	ip address x.x.x.x/x
	ipv6 enable
	ipv6 address 2000:100::1/64
	exit
```

### Маршруты
---
Маршрут в сеть (v6 аналогично):
```
ip route x.x.x.x/x nexthop
```

Маршрут по умолчанию (v6 аналогично):
```
ip route 0.0.0.0/0 nexthop
```

### DHCP-сервер + Relay
---

1. Создаем пул:
```
ip dhcp-server pool "LOCAL-POOL-1"
	network 172.16.1.0/24
	address-range 172.16.1.200-172.16.1.250
	excluded-address-range 172.16.1.201-172.16.1.210
	default-router 172.16.1.1
	domain-name "au.team"
	dns-server 77.88.8.8
	exit
```

2. Включаем сервер:
```
ip dhcp-server
```

`Relay`:
1. На интерфейсе в сторону LAN пишем адрес DHCP-сервера:
```
ip helper-address 10.0.10.1
```

2. В глобальном конфиге включаем relay:
```
ip dhcp-relay
```

### SourceNAT
---
1. Создаем зону безопасности:
```
security zone "public"
```

2. Помещаем интерфейс в сторону инета в зону безопасности:
```
interface gi1/0/2
	security-zone public
	exit
```

3. Создаем группу объектов для помещения туда диапазона адресов LAN:
```
object-group network LAN
	ip address-range 10.0.10.1-10.0.10.254
	exit
```

4. Начинаем настройку SourceNAT:
```
nat source
	ruleset MASQUERADE
		to zone public
		rule 1
			description MASQUERADE
			match source-address LAN
			action source-nat interface
			enable
			end
```

### GRE + IPSEC
---
#### GRE

1. Создание и настройка туннельного интерфейса:
```
tunnel gre 1
	ttl 16
	ip firewall disable 
	local address 192.168.1.2
	remote address 192.168.2.2
	ip address 10.0.10.1/30
	enable
	end
```

2. Статический маршрут:
```
ip route 172.16.2.0/24 10.0.10.2
```

#### IPSEC

1. Профиль протокола IKE:
```
security ike proposal ike_prop1
	authentication algorithm md5
	encryption algorithm aes128
	dh-group 2
	exit
```

2. Политика протокола IKE:
```
security ike policy ike_pol1
	pre-shared-key ascii-text P@ssw0rd
	proposal ike_prop1
exit
```

3. Шлюз протокола IKE:
```
security ike gateway ike_gw1
	ike-policy ike_pol1
	local address 11.11.11.11
	local network 11.11.11.11/32 protocol gre 
	remote address 22.22.22.22
	remote network 22.22.22.22/32 protocol gre 
	mode policy-based
	exit
```

4. Профиль параметров безопасности для IPsec-туннеля:
```
security ipsec proposal ipsec_prop1
	authentication algorithm md5
	encryption algorithm aes128
	pfs dh-group 2
	exit
```

5. Политика для IPsec-туннеля:
```
security ipsec policy ipsec_pol1
	proposal ipsec_prop1
	exit
```

6. IPsec VPN:
```
security ipsec vpn ipsec1
	ike establish-tunnel route
	ike gateway ike_gw1
	ike ipsec-policy ipsec_pol1
	enable
	exit
```

### OSPF
---

#### Базовая настройка

1. В глобальном конфиге:
```
router ospf 1
	router-id 1.1.1.1
	area 0.0.0.0
		network 172.16.2.0/24
		network 10.0.10.0/30
		enable
		exit
	enable
	exit
```

2. На gre-туннеле/интерфейсе:
```
tunnel gre 1
	ip ospf instance 1
	ip ospf
```

#### Аутентификация 

1. Создаем ключ:
```
key-chain ospf
	key 1
		key-string ascii-text P@ssw0rd
		exit
	exit
```

2. Выбираем метод аутентификации md5 и добавляем ключ:
```
tunnel gre 1
	ip ospf authentication key-chain ospf
	ip ospf authentication alhorithm md5
```

#### Смена типа подключения
---
1. На туннельном интерфейсе:
```
tunnel gre 1
	ip ospf network point-to-point
```

### RoaS
---
1. Создать подинтерфейс:
```
interface gi1/0/2.100
```

2. Отключить фаервол и назначить ему IP-адрес:
```
ip firewall disable
ip address 172.16.100.1/24
```

### VRRP
---
#### R1

```
interface gi1/0/2
	ip firewall disable
	ip address 172.16.100.1
	vrrp id 100
	vrrp ip 172.16.100.254/32
	vrrp priority 150
	vrrp
```

#### R2

```
interface gi1/0/2
	ip firewall disable
	ip address 172.16.100.2
	vrrp id 100
	vrrp ip 172.16.100.254/32
	vrrp priority 100
	vrrp
```

### VRRP + RoaS
---
#### R1

`VLAN100`:
```
interface gi1/0/2.100
	ip firewall disable
	ip address 172.16.100.1
	vrrp id 100
	vrrp ip 172.16.100.254/32
	vrrp priority 150
	vrrp
```

`VLAN200`:
```
interface gi1/0/2.200
	ip firewall disable
	ip address 172.16.200.1
	vrrp id 200
	vrrp ip 172.16.200.254/32
	vrrp priority 150
	vrrp
```

#### R2

`VLAN100`:
```
interface gi1/0/2.100
	ip firewall disable
	ip address 172.16.100.2
	vrrp id 100
	vrrp ip 172.16.100.254/32
	vrrp priority 100
	vrrp
```

`VLAN200`:
```
interface gi1/0/2.200
	ip firewall disable
	ip address 172.16.200.2
	vrrp id 200
	vrrp ip 172.16.200.254/32
	vrrp priority 100
	vrrp
```