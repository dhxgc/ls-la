# Rsyslog на Alte
> Источник: https://docs.altlinux.org/ru-RU/domain/10.4/html/samba/ch06s16s09.html и https://github.com/dhxgc/as25-writeups/tree/main/scipts/rsyslog

#### 1. Установка:
```bash
apt-get install rsyslog-classic
```

#### 1.1. Накинуть права на директорию с логами:
> Если отличается от стандартной, иначе лучше так не делать. Права примерные, с такими завелось
```bash
chmod 775 -R /opt/logs
chown root:adm -R /opt/logs
```

#### 2. Открыть TCP/UDP

#### 3. Создать шаблон:
```
# /etc/rsyslog.d/00_common.conf
$template RemoteLogs,"/opt/log/%HOSTNAME/%PROGRAMNAME.log"
*.* ?RemoteLogs
```