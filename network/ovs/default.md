# Базовое в OVSе

#### Создать бридж:
```bash
ovs-vsctl add-br br0
```

#### Добавить порт в бридж:
```bash
ovs-vsctl add-port br0 ens3
```

#### Удалить порт:
> Бридж не важен, он его просто хуйнет отовсюду
```bash
ovs-vsctl del-port ens3
```

#### Посмотреть настройки порта:
```bash
ovs-vsctl list port ens4
```

### Почистить параметр у порта:
```bash
ovs-vsctl set port tag=[]
```

#### Посмотреть настройки бриджа:
> С большой буквы!!!
```bash
ovs-vsctl list Bridge br0
```