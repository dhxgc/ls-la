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
```
sudo openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt
```
Далее пояснения:

-`req`: Указывает, что мы создаём запрос на сертификат (CSR).

-`x509`: Генерирует самоподписанный сертификат, вместо запроса на сертификат (CSR).

-`sha256`: Указывает использовать алгоритм SHA-256 для подписи сертификата, что добавляет уровень безопасности.

-`nodes`: Указывает, что приватный ключ не будет зашифрован (без пароля).

-`newkey rsa:2048`: Генерирует новую пару ключей RSA длиной 2048 бит одновременно с запросом на сертификат.

-`days 365`: Указывает, что сертификат будет действительным в течение 365 дней.

-`keyout localhost.key`: Имя файла, в который будет сохранён приватный ключ.

-`out localhost.crt`: Имя файла, в который будет сохранён самоподписанный сертификат.

# NGINX

apt install nginx

nano /etc/nginx/sites-available/example.com

сам конфиг:
```
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

    root /var/www/example.com/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

nano /var/www/example.com

конфиг html-странички любой, например: 

```
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

chown -R www-data:www-data /var/www/example.com/html

chmod -R 755 /var/www/example.com

nginx -t

systemctl restart nginx

# Несколько виртуальных хостов

Если есть необходимость поднять несколько виртуальных хостов на локалхосте - необходимо в /etc/hosts прописать их server_name в строчку на любом ипишнике из 127 сети, можно на разных. После чего в ОТДЕЛЬНОМ конфиге поменяется лишь `server_name` и `root`-папка, которую необходимо создать вместе с .html-файлом. Далее можно проверять и переходить по этим server_name'ам. Серты остаются теми же (самоподписанные).
