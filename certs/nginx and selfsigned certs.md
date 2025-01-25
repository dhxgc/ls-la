# Генерация сампоподписанного сертификата 

Шаги для генерации самоподписанного сертификата:
```
sudo apt install openssl
```
Создание приватного ключа:
```
openssl genrsa -out server.key 2048
```
Создание запроса на сертификат (CSR):
```
openssl req -new -key server.key -out server.csr
```
Создание самоподписанного сертификата, используя созданный CSR и приватный ключ:
```
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```
Проверка сертификата:
```
openssl x509 -in server.crt -text -noout
```
---
**Есть вариант проще и быстрее, который выполняет все те же действия, но за одну команду:**
---
```
sudo openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt
```
Далее пояснения:

-`req`: указывает, что мы создаём запрос на сертификат (CSR).

-`x509`: генерирует самоподписанный сертификат, вместо запроса на сертификат (CSR).

-`sha256`: указывает использовать алгоритм SHA-256 для подписи сертификата

-`nodes`: указывает, что приватный ключ не будет зашифрован (без пароля).

-`newkey rsa:2048`: генерирует новую пару ключей RSA длиной 2048 бит одновременно с запросом на сертификат.

-`days 365`: указывает, что сертификат будет действительным в течение 365 дней.

-`keyout localhost.key`: имя файла, в который будет сохранён приватный ключ.

-`out localhost.crt`: имя файла, в который будет сохранён самоподписанный сертификат.

---

# NGINX

Устанавливаем пакет nginx:
```bash
apt install nginx
```

Создаем конфигурационный файл:
```bash
nano /etc/nginx/sites-available/servername.conf
```
Приводим к виду (самая базовая реализация):
```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/ssl/certs/example.com.crt;
    ssl_certificate_key /etc/ssl/private/example.com.key;

    root /var/www/;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```
После чего создаем символическую ссылку, которая сделает виртуальный хост активным:
```bash
ln -s /etc/nginx/sites-available/servername.conf /etc/nginx/sites-enabled/
```

Далее в папке, которую указывали в `root ...` (например /var/www) нужно будет создать html-файл, который будет использоваться веб-сервером и отображаться в браузере:
```bash
nano /var/www/index.html
```
Конфиг html-странички любой, например (можно значительно проще): 

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<meta name='author' content='Administrator'>
<meta name='description' content='!SITENAME!'>
<meta name="robots" content="all">
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>123</title>
</head>
<body>
123
</body>
</html>
```

Изменяем владельца и выдаем права на файл, чтобы не возникло ошибок при взаимодействии веб-сервера с ним:
   ```bash
   chown -R www-data:www-data /var/www/
   chmod -R 755 /var/www/index.html
   ```
Проверяем конфигурацию nginx на ошибки:
```bash
nginx -t
```
И перезапускаем:
   ```bash
   sudo systemctl restart nginx
   ```
# Несколько виртуальных хостов

Если есть необходимость поднять несколько виртуальных хостов на локалхосте - необходимо в /etc/hosts прописать их server_name в строчку на любом ипишнике из 127 сети, можно на разных. После чего в ОТДЕЛЬНОМ конфиге поменяется лишь `server_name` и `root`-папка, которую необходимо создать вместе с .html-файлом. Далее можно проверять и переходить по этим server_name'ам. Серты остаются теми же (самоподписанные).
