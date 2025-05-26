# Rsnapshot в Alte

> Везде табы, пробелов не должно быть

#### 1. Установить, бекапы
```bash
apt-get install rsnapshot -y
cp -r /etc/rsnapshot/rsnapshot.conf{,.bak}
```

#### 2. Правка конфиги, проверка
```bash
# Темплейт рядом лежит
rsnapshot configtest
```

#### 3. Добавить таски в крон:
```cron
0 */1 * * * /usr/bin/rsnapshot hourly
0 0 */1 * * /usr/bin/rsnapshot daily
0 0 * * 0 /usr/bin/rsnapshot weekly
0 0 0 */1 * /usr/bin/rsnapshot monthly
```