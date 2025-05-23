# Центр сертификации

### Важные моменты:
1. После поднятия в логах будет запись, которая нужна для управлялки на клиенте, по типу:
```log
step-ca  | 2025/05/23 12:08:06 X.509 Root Fingerprint: 9a9c8189a92b5113935745d67c1ff3055d40cb97be3f7fec6e9ec79476817b04
```
2. Для управлялки есть автокомплит, нужно из `step_linux_amd64/autocomplete/bash_autocomplete` функцию и вызов скопировать в `/etc/bashrc` или `~/.bashrc`

<br>

---

<br>

#### 1. Поднять:
> Не может создавать файлы, поэтому просто 777 на все тома
```bash
chmod 777 -R ./*
docker compose up -d
```

#### 2. Управлялка на клиента:
```bash
curl -fSL https://github.com/smallstep/cli/releases/latest/download/step_linux_amd64.tar.gz | tar -xzv
mv step_linux_amd64/bin/step /usr/local/bin
```

#### 2.1. Серт в доверенные:
```bash
cp ~/.step/certs/root_ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust
```

#### 3. Подцепиться к серверу:
> HASH брать из пункта в начале
```bash
step ca bootstrap --ca-url https://<step-ca-ip>:9000 --fingerprint ___HASH___
```

#### 4.  Выпуск сертов:
> `provisioner` - из композа, вместо `example.local` - ___нужный CN___
```bash
step ca certificate \
  "example.local" \
  example.crt \ 
  example.key \
  --provisioner admin@example.com
```

