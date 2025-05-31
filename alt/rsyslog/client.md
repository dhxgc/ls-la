# Rsyslog-клиент на Alte

#### 1. Установить:
```bash
apt-get install rsyslog-classic
```

#### 2. Указать сервер:
```bash
# /etc/rsyslog.conf
*.* @@192.168.122.23
```