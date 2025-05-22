# Одна из реализаций NAT'а на Eltex'e
> Источник: https://sysahelper.ru/mod/page/view.php?id=339&forceview=1
---
> Если надо сделать NAT для еще каких-то сетей - повторить шаг 3 и 5
---

#### 1. Security Zone:
> Просто чтобы указать, что трафик который пойдет в эту зону - натить
```cisco
config
  security zone Internet
exit
```

#### 2. Кинуть WAN-порт в зону Internet:
```cisco
interface gi1/0/1
  security-zone public 
exit
```

#### 3. Создать пул с локальными адресами:
```cisco
object-group network VLAN10
  ip address-range 10.0.10.1-10.0.10.254
exit
```

#### 4. Набор правил для NAT:
> Название - вроде любое. В нем уже хранятся сами правила.
```cisco
nat source
  ruleset MASQUERADE
    to zone Internet
```

#### 5. Правило для VLAN10:
> Для каждой сети свое правило
```cisco
rule 1
  description "masqureade"
  match source-address VLAN10
  action source-nat interface
  enable
exit
```