> Источник - [[Документация]](https://help.mikrotik.com/docs/spaces/ROS/pages/328068/Bridging+and+Switching#BridgingandSwitching-VLANExample-TrunkandAccessPorts)
## `Router on a stick` на CHR:

### На коммутаторе:
1. Создать бридж:
```routeros
/interface bridge
add name=bridge1 vlan-filtering=no
```

2. Сделать порт транком (например, до роутера):
```routeros
/interface bridge port
add bridge=bridge1 interface=ether2 frame-types=admit-only-vlan-tagged
```

2.1 Определить разрешенные vlan на транке:
```routeros
/interface bridge vlan
add bridge=bridge1 tagged=ether2 vlan-ids=200 
add bridge=bridge1 tagged=ether2 vlan-ids=300
add bridge=bridge1 tagged=ether2 vlan-ids=400
```

3. Определить access-порты:
```routeros
/interface bridge port
add bridge=bridge1 interface=ether6 pvid=200 frame-types=admit-only-untagged-and-priority-tagged
add bridge=bridge1 interface=ether7 pvid=300 frame-types=admit-only-untagged-and-priority-tagged
add bridge=bridge1 interface=ether8 pvid=400 frame-types=admit-only-untagged-and-priority-tagged
```

4. Включить vlan-фильтрацию:
```routeros
/interface bridge set bridge1 vlan-filtering=yes
```

### На роутере:
1. Добавить vlan-интерфейсы:
```routeros
interface vlan add name=vlan400 interface=ether2 vlan-id=400 disabled=no arp=enabled
interface vlan add name=vlan200 interface=ether2 vlan-id=200 disabled=no arp=enabled
interface vlan add name=vlan300 interface=ether2 vlan-id=300 disabled=no arp=enabled
```

2. Назначить IP на vlan-интерфейсы:
```routeros
ip address add interface=vlan200 address=10.0.20.1/24 disabled=no
ip address add interface=vlan300 address=10.0.30.1/24 disabled=no
ip address add interface=vlan400 address=10.0.40.1/24 disabled=no
```