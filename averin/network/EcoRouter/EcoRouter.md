### Диагностика/проверка
---
```
show port
show port brief
show service-instance brief
show interface
show ip int brief
show dhcp-server <number> detailed
show dhcp-server clients <interface>
show dhcp-profile <number>
show ip nat translations
show vrrp
```

### Базовая настройка
---
Хостнеймы:
```
hostname R*
```

Если нужно убрать отключение от линии через 10 минут:
```
line console 0
	exec-timeout 0 
	exit
```
Аналогично можно сделать для всех виртуальных терминальных линий:
```
line vty 0 871
```

Пароль на enable:
```
enable secret P@ssw0rd
```

Шифрование паролей:
```
service password-encryption
```

Баннер:
```
banner motd 123123
```

### IP-адреса
---
Поставить ip на виртуальный интерфейс:
```
interface int0
	ip address 192.168.1.2/24
```

Создать на физическом порту service-instance, указать нетегированный трафик и подключить виртуальный интерфейс:
```
port ge0
	service-instance WAN
		encapsulation untagged
		connect ip interface int0
```
Если нужны vlan:
```
port ge1
	service-instance WAN
		encapsulation dot1q
		rewrite pop ?
		connect ip interface int1
```

loopback-интерфейсы (не цепляются к инстансам):
```
interface loopback.1
	ip address 10.1.0.1/24
	no shutdown
exit
```

### Маршруты
---
Маршрут по умолчанию:
```
ip route 0.0.0.0/0 192.168.1.1
```

Маршрут с указанием административной дистанции (приоритет):
```
ip route 0.0.0.0/0 192.168.1.1 80
```

Машрут к loopback (при наличии прямого подключения):
```
ip route 10.2.0.0/24 192.168.1.1
```

### VLAN
---
1. Виртуальный интерфейс:
```
interface int3
	description "vlan3"
	ip address 192.168.3.1/24
	exit
```

2. Порт и сервис инстанс с указанием инкапсуляции и операции снятия метки:
```
port ge0
	service-instance ge0/int3
		encapsulation dot1q 3 exact 
		rewrite pop 1
		connect ip interface int3
		exit
```

### SourceNAT
---
1. Расставляем inside/outside на интерфейсах:
```
interface int0 
	ip nat outside
interface int1
	ip nat inside
```

2. Создаем пул source-адресов, которые будут натиться:
```
ip nat pool NAME 172.16.1.1-172.16.1.255
```

3. Включаем динамическую трансляцию пула через внешний адрес:
```
ip nat source dynamic inside-to-outside pool NAME overload 192.168.1.2
```

### DestinationNAT 
---
1. Расставляем inside/outside на интерфейсах:
```
interface int0 
	ip nat outside
interface int1
	ip nat inside
```

2. Правило для проброса порта:
```
ip nat source static tcp 172.16.1.11 22 192.168.1.2 2222
```
`Сначала - внутренний (destination), потом - внешний (интерфейс маршрутизатора во внешку)`

### DHCP + Relay
---
1. Создание пула адресов:
```
ip pool LAN 192.168.1.20-192.168.1.50
```

2. Настройка сервера с выбранным пулом:
```
ip dhcp-server 1
	pool LAN 1
		gateway 192.168.1.1
		dns 192.168.1.1
		domain-name au.team
```

3. Назначение сервера на интерфейс:
```
interface int 1
	dhcp-server 1
```
 
Ретрансляция:
```
dhcp-profile 0
	server 192.168.1.254
	mode relay
interface int1
	dhcp-profile 0
```
### Создание пользователя + админские права
---
1. Создание пользователя с правами администратора:
```
username sshuser
	password P@ssw0rd
	role admin
```

2. Для просмотра списка пользователей и их прав можно использовать:
```
show users localdb
```

### Разрешение SSH + профили безопасности и VRF
---
Все работает через vrf и профили безопасности, в дефолтном профиле безопасности запрещен доступ по ssh.

1. Создаем свой профиль, разрешая что угодно (в нашем случае доступ по ssh):
```
security-profile 1
	rule 1 permit/deny protocol source destination [eq port number]
```
Есть также вариант использовать уже созданный профиль `none`.

2. Если есть необходимость создать отдельную vrf :
```
ip vrf vrf_name
```

3. Применение профиля к vrf:
```
security profile_name vrf vrf_name
```

### GRE
---
1. Создаем туннельный интерфейс, прописываем адрес, mtu и параметры туннеля:
```
interface tunnel.0
	ip address 
	ip mtu 1400
	ip tunnel source destination mode gre
```

2. Прописываем маршрут с nexthop на другом конце туннеля:
```
ip route 192.168.1.0/24 10.0.0.2
```

### IPSEC ???
---

### OSPF
---
1. Прописываем все необходимые параметры:
```
router ospf 1
	ospf router-id 1.1.1.1
	network 172.16.1.0 0.0.0.255 area 0
	network 10.0.0.0 0.0.0.255 area 0
	passive-interface default
	no passive-interface tunnel.0
```

2. Прописываем тип сети и md5 аутентификации на туннеле:
```
 ip ospf network point-to-point
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 P@ssw0rd
```

### ROAS
---
1. Настраиваем виртуальный интерфейс:
```
interface int1.100
	ip address 172.16.100.1/24
```

2. Настраиваем service-instance:
```
port ge1
	service-instance 100
		encapsulation dot1q 100 exact
		rewrite pop 1
		connect ip interface int1.100
```


### VRRP
---
1. Включаем VRRP:
```
vrrp compatible-v2 enable
```

2. Указание группы и интерфейса:
```
router vrrp 1 e0
```

3. Виртуальный адрес:
```
virtual-ip 192.168.1.254
```

4. Приоритет:
```
priority 150
```

5. Время ожидания, после которого восстановятся анонсы:
```
switch-back-delay 5000
```

6. Совместимость со второй версией:
```
v2-compatible
```

7. Включаем режим принятия трафика непосредственно к виртуальному адресу:
```
accept-mode true
```

8. Включаем:
```
enable
```

---
```
vrrp compatible-v2 enable
router vrrp 1 e0
	virtual-ip 192.168.1.254
	priority 150
	switch-back-delay 5000
	v2-compatible
	accept-mode true
	enable
	exit
```
---

### VRRP + ROAS
---
#### R1

1. Интерфейс и service-instance:
```
interface int1.100
	ip address 172.16.100.1/24

port ge1
	service-instance 100
		encapsulation dot1q 100 exact
		rewrite pop 1
		connect ip interface int1.100
```

2. Настройка VRRP:
```
vrrp compatible-v2 enable
router vrrp 100 int1.100
	virtual-ip 172.16.100.254
	priority 150
	switch-back-delay 5000
	v2-compatible
	accept-mode true
	enable
	exit
```

1. Интерфейс и service-instance:
```
interface int1.200
	ip address 172.16.200.1/24

port ge1
	service-instance 200
		encapsulation dot1q 200 exact
		rewrite pop 1
		connect ip interface int1.200
```

2. Настройка VRRP:
```
vrrp compatible-v2 enable
router vrrp 200 int1.200
	virtual-ip 172.16.200.254
	priority 150
	switch-back-delay 5000
	v2-compatible
	accept-mode true
	enable
	exit
```

#### R2

1. Интерфейс и service-instance:
```
interface int1.100
	ip address 172.16.100.2/24

port ge1
	service-instance 100
		encapsulation dot1q 100 exact
		rewrite pop 1
		connect ip interface int1.100
```

2. Настройка VRRP:
```
vrrp compatible-v2 enable
router vrrp 100 int1.100
	virtual-ip 172.16.100.254
	priority 100
	switch-back-delay 5000
	v2-compatible
	accept-mode true
	enable
	exit
```

1. Интерфейс и service-instance:
```
interface int1.200
	ip address 172.16.200.2/24

port ge1
	service-instance 200
		encapsulation dot1q 200 exact
		rewrite pop 1
		connect ip interface int1.200
```

2. Настройка VRRP:
```
vrrp compatible-v2 enable
router vrrp 200 int1.200
	virtual-ip 172.16.200.254
	priority 100
	switch-back-delay 5000
	v2-compatible
	accept-mode true
	enable
	exit
```