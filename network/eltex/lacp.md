# Просто бонды

> После настройки работать как с обычным физ. портом

Создать бонд:
```cisco
interface port-channel <ID>
```

Закинуть порты в бонд:
```cisco
interface gi1/0/1
channel-group <ID> mode auto

interface gi1/0/2
channel-group <ID> mode auto
```

Проверить:
```cisco
show lacp interfaces
show lacp parameters
```