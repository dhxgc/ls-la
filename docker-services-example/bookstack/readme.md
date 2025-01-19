# Про Bookstack
Источники:
> 1. Про SMTP и пользователей - https://www.bookstackapp.com/docs/admin/email-webhooks/
> 2. Про установку - https://www.bookstackapp.com/docs/admin/installation/#shared
> 3. Описание установки именно в докере - https://github.com/linuxserver/docker-bookstack?tab=readme-ov-file
---

! Надо указывать переменную `APP_KEY`, нужен для шифрования сеанса. Генерируется командой:
```bash
run -it --rm --entrypoint /bin/bash lscr.io/linuxserver/bookstack:latest appkey
```

---

! Всегда нужно указывать `APP_URL`, а именно адрес, по которому будет работать приложение. Без него сайт не запустится и будет редиректить на `example.com`. 

Пример: `APP_URL='https://10.6.1.62/bookstack'`

---

! При использовании с обратным прокси, например при: 
```json
location /bookstack/ {
    proxy_pass http://bookstack:80/;
}
```
надо будет учитывать и `/bookstack`, то есть, `APP_KEY` должен быть `APP_URL='https://10.6.1.62/bookstack'`

---

# nginx proxy:

```json
	location /bookstack/ {
		proxy_pass http://bookstack:80/; 

		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr:$remote_port;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;

		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection 'upgrade';
		proxy_set_header Accept-Encoding '';
		proxy_set_header Referer $http_referer;
		proxy_set_header Cookie $http_cookie;
		proxy_set_header X-Forwarded-Host $host;
		proxy_set_header X-Forwarded-Server $host;
	}
```