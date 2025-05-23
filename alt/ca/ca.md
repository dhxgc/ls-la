# CA на Altе
> Источник: https://sysahelper.ru/mod/page/view.php?id=134

#### Параметры в storage-configs/openssl.cnf:
 - 143 строка - Имя организации:
``` 
0.organizationName_default = kk.domain
```
 - 75 строка - Срок жизни:
```
default_days = 365
```
 - 45 строка - Директория ЦС:
```
dir = /ca
```

---

#### 1. Поменять все что надо в `openssl.cnf`

#### 2. Запустить скрипт `openssl-ca.sh`