# Бонды в etcnet
> Источник: https://www.altlinux.org/Etcnet#%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_bonding

#### 1. `options` у slave-интерфейсов:
```
TYPE=eth
BOOTPROTO=static
```

#### 2. `options` на bond'е:
```
TYPE=bond
BOOTPROTO=static
HOST="eth0 eth1"
BONDMODE=1
BONDOPTIONS="miimon=100"
```

#### 3. Поглазеть на бонд:
```bash
cat /proc/net/bonding/bond0
```

---

1. Типы бондов:
    - `BONDMODE=0` - balance-rr
    - `BONDMODE=1` - active-backup
    - `BONDMODE=2` - balance-xor
    - `BONDMODE=3` - broadcast
    - `BONDMODE=4` - 802.3ad
    - ...