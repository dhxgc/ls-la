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

2. Конфига для `https` валяется в `sample3`. Серты нужны особенные, с подстановочным знаком. Чтобы добавить серты (letsencrypt в данном случае), надо скопировать их в `./ssl/` в виде `sish.domain.ru.crt` и `sish.domain.ru.key`
```bash
# Пример для Let's Encrypt
cp /etc/letsencrypt/live/sish.bubbles-averin.ru/fullchain.pem sish/ssl/sish.bubbles-averin.ru.crt
cp /etc/letsencrypt/live/sish.bubbles-averin.ru/privkey.pem sish/ssl/sish.bubbles-averin.ru.key
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

3. Если включен `https`, то выдавать надо также на 80 порт, а 443 оно подтянет автоматом:
```bash
ssh -p 2222 -R pc:80:localhost:8000 root@sish.atom25.local
```