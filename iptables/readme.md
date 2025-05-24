## Базовые команды

 - Alt. Сохранить правила:
```bash
iptables-save > /etc/sysconfig/iptables
```

 - Удалить правило из цепочки:
```bash
iptables -t nat -D POSTROUTING 1
```

 - Удалить все правила из цепочки:
```bash
iptables -t nat -F POSTROUTING
```