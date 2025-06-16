# `sish`

> self-hosted варик по типу `ngrok`
> 
> Предварительно, нужно создать запись `*.sish.atom25.local`, которая указывает на IP сервера

---

<br>

Развертывание:
1. Добавить аутентификацию по паролю:
> В `docker-compose.yml`, в раздел `command`
```bash
--authentication=true
--authentication-password=P@ssw0rd
```

<br>

---

<br>

Использование у клиента:
1. Локальный порт `8080` опубликовать на `80` порту и домене `subdomain.sish.atom25.local`:
```bash
ssh -p 2222 -R subdomain:80:localhost:8080 sish.atom25.local
```

2. Локальный порт `8080` опубликовать на 3000 порту:
```bash
ssh -p 2222 -R 3000:localhost:8080 sish.atom25.local
```