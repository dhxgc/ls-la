# RSTP в OVSе

> Если в кольце есть бонды, то они ___ДОЛЖНЫ БЫТЬ___ в `active-backup`. 
> 
> Лучше всего - не средствами OVS, а `etcnet`/`ifupdown2`. 
> 
> Потом в бридж добавлять уже сам бонд, чтобы блокировался весь интерфейс

#### 1. Включить RSTP:
> На всех коммутаторах
```bash
ovs-vsctl set Bridge br0 rstp_enable=true

# Опционально, работает без этого
ovs-vsctl set Bridge br0 other-config:stp-enable=false
ovs-vsctl set Bridge br0 other-config:rstp-enable=true
```

#### 2. Выставить приоритет:
```bash
ovs-vsctl set Bridge br0 other-config:rstp-priority=4096
```

#### 3. Проверка:
```bash
ovs-appctl rstp/show
```
