## Базовые команды

 - Удалить правило из цепочки:
```bash
iptables -t nat -D POSTROUTING 1
```

 - Удалить все правила из цепочки:
```bash
iptables -t nat -F POSTROUTING
```