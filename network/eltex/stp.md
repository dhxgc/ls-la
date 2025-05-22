# Все что про петли

Напоминание:
> PortFast - сразу поднимает интерфейс, не ждет таймеров от STP. Включается на портах с клиентами

### Диагностика:

Посмотреть инфу по STP:
```cisco
show spanning-tree active
```

---

### Настройка

Назначить приоритет коммутатору:
```cisco
config
spanning-tree priority 4096
```

PortFast:
```cisco
interface gi1/0/1
spanning-tree portfast
```

Не нашел про BPDU-Guard, но можно просто выключить STP на интерфейсе:
```cisco
interface gi1/0/1
spanning-tree disable
```