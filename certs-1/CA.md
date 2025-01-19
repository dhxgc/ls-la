---
# Важно!
---
Везде, где прописано требование указать <server_name> он должен быть одинаковым, ибо под конец возникает предупреждение SSL_ERROR_BAD_CERT_DOMAIN, которое указывает на то, что название серта не соответствует доменному имени в конфиге nginx, точнее в строке server_name.
---
### Этап 1: Установка и настройка Easy-RSA на HQ-SRV

1. **Установка Easy-RSA**:
   ```bash
   sudo apt update
   sudo apt install easy-rsa
   ```

2. **Создание структуры каталогов**:
   ```bash
   mkdir ~/easy-rsa
   cd ~/easy-rsa
   cp -r /usr/share/easy-rsa/* .
   ```

3. **Инициализация PKI**:
   ```bash
   ./easyrsa init-pki
   ```

4. **Создание корневого сертификата**:
   ```bash
   ./easyrsa build-ca
   ```

### Этап 2: Выдача сертификатов веб-серверам

1. **Создание сертификатов для веб-серверов**:
   Для каждого веб-сервера (например, moodle, wiki, nginx), выполните:
   ```bash
   ./easyrsa gen-req <server_name> nopass
   ./easyrsa sign-req server <server_name>
   ```
   Замените `<server_name>` на соответствующее имя серверов.

### Этап 3: Перенос сертификатов на HQ-CLI

1. **Экспорт корневого сертификата**:
   Скопируйте `ca.crt`, `server.crt`, и `server.key` для каждого веб-сервера на клиент HQ-CLI:
   ```bash
   scp pki/ca.crt user@HQ-CLI:/path/to/certs/
   scp pki/issued/<server_name>.crt user@HQ-CLI:/path/to/certs/
   scp pki/private/<server_name>.key user@HQ-CLI:/path/to/certs/
   ```

2. **Добавление корневого сертификата в доверенные**:
   На HQ-CLI добавьте `ca.crt` в систему:
   ```bash
   sudo cp /path/to/certs/ca.crt /usr/local/share/ca-certificates/
   sudo update-ca-certificates
   ```

### Этап 4: Перенастройка веб-серверов

1. **Перенастройка Nginx**:
   Для каждого веб-сервера создайте или отредактируйте конфигурацию:
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
   ```bash
   sudo systemctl restart nginx
   ```
Далее необходимо выставить права доступа на сертификат корневого сервера ca.crt, созданный командой `build-ca`:
```
chmod 644 /path/to/certs/ca.crt 
```
После этого нужно импортировать сертификат в firefox через `Настройки -> Приватность и Защита -> Сертификаты -> Просмотр сертификатов -> Импортировать (с обеими галочками)`.

После этого должно без каких-либо предупреждений переходить по доменному имени конкретно в firefox.
