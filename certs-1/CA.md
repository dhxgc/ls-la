
# Важно!

Везде, где прописано требование указать `<server_name>` он должен быть одинаковым, ибо под конец возникает предупреждение `SSL_ERROR_BAD_CERT_DOMAIN`, которое указывает на то, что название сертификата не соответствует доменному имени в конфиге nginx, точнее в строке `server_name`.

---
# Теория

Перед тем как начать настройку корневого центра сертификации опишу несколько вещей. 

`Что такое PKI? `

PKI - инфраструктура открытых ключей, набор технологий, правил, протоколов и всего что с ними связано, отвечающий за безопасность коммуникаций в интернете. Включает в себя центры сертификации, любые сертификаты, ключи и протоколы.

`Что такое утилита EasyRsa?`

EasyRsa - инструмент на основе OpenSSL, упрощающий процессы создания и управления PKI. Собственно, имеет весь необходимый функционал: позволяет создавать сертификаты для корневого сервера и подписывать обычные, создавать ключи для различных шифрований.

`За что отвечает команда ./easyrsa init-pki?`

Эта команда запускает инициализацию инфраструктуры открытых ключей, конкретнее - создает директории и конфигурационные файлы, описывающие параметры. Будут созданы следующие директории:
- ca - для сертификата самого центра сертификации;
- issued - для выданных (подписанных) сертификатов;
- private - для закрытых/приватных ключей;
- reqs - для запросов на сертификаты (CSR).
---
# Практика
Первым делом необходимо установить пакет easy-rsa:
   ```bash
   sudo apt update
   sudo apt install easy-rsa
   ```
Далее создаем папку и переносим в нее все необходимые файлы, включая исполняемый для запуска утилиты:
   ```bash
   mkdir ~/easy-rsa
   cd ~/easy-rsa
   cp -r /usr/share/easy-rsa/* .
   ```

Далее запускаем инициализацию инфраструктуры открытых ключей PKI (создаются папки + конф. файлы):
   ```bash
   ./easyrsa init-pki
   ```

Теперь необходимо создать сертификат для нашего корневого ЦС:
   ```bash
   ./easyrsa build-ca
   ```

После этого, создаем сертификаты для клиента нашего корневого центра сертификации:
   ```bash
   ./easyrsa gen-req <server_name> nopass
   ./easyrsa sign-req server <server_name>
   ```

На данном этапе корневой сертификат, закрытый ключ и сертификат для конкретного сервиса созданы. Если сервис поднимается на удаленном сервере - необходимо перенести сертификаты и ключ туда. Это можно сделать разными способами, далее будет рассматриваться команда scp:
   ```bash
   scp pki/ca.crt user@[ip|hostname]:/path/to/certs/
   scp pki/issued/<server_name>.crt user@[ip|hostname]:/path/to/certs/
   scp pki/private/<server_name>.key user@[ip|hostname]:/path/to/certs/
   ```
Теперь для удаленного сервера необходимо добавить полученный `сертификат корневого сервера` в качестве `доверенного`, реализуется следующим способом:
   ```bash
   sudo cp /path/to/certs/ca.crt /usr/local/share/ca-certificates/
   sudo update-ca-certificates
   ```
Чтобы настроить nginx для работы с сертификатами, необходимо создать конфигурационный файл в папке `/etc/nginx/sites-available/`, например `servername.conf`, после чего привести его к следующему виду (представлена самая базовая конфигурация):
   ```nginx
   server {
       listen 443 ssl;
       server_name your_domain;

       ssl_certificate /path/to/certs/<server_name>.crt;
       ssl_certificate_key /path/to/certs/<server_name>.key;
       
       location / {
           root /path/to/your/web/files;
           index index.html index.htm;
       }
   }

   server {
       listen 80;
       server_name your_domain;
       return 301 https://$host$request_uri;
   }
   ```
После чего создаем символическую ссылку, которая сделает виртуальный хост активным:
   ```bash
   ln -s /etc/nginx/sites-available/servername.conf /etc/nginx/sites-enabled/
   ```
Далее в папке, которую указывали в `root ...` (например /var/www) нужно будет создать html-файл, который будет использоваться веб-сервером и отображаться в браузере:
   ```bash
   nano /var/www/
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
Далее необходимо выставить права доступа на сертификат корневого сервера ca.crt, созданный командой `build-ca`:
```
chmod 644 /path/to/certs/ca.crt 
```
После этого нужно импортировать сертификат в firefox через:

`Настройки -> Приватность и Защита -> Сертификаты -> Просмотр сертификатов -> Импортировать (с обеими галочками)`.

После этого должно без каких-либо предупреждений переходить по доменному имени конкретно в firefox.
