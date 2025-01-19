Для выполнения задания по настройке центра сертификации на базе сервера HQ-SRV с использованием отечественных алгоритмов шифрования, а также перенастройки веб-серверов на HTTPS, следуйте этой пошаговой инструкции.

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
   Откройте файл `vars` и укажите нужные значения. Убедитесь, что используете отечественные алгоритмы, такие как Гост Р 34.11-94 для хеширования.

   ```bash
   nano vars
   ```

   Добавьте:
   ```bash
   set_var EASYRSA_REQ_COUNTRY    "RU"
   set_var EASYRSA_REQ_PROVINCE   "YourProvince"
   set_var EASYRSA_REQ_CITY       "YourCity"
   set_var EASYRSA_REQ_ORG        "YourOrg"
   set_var EASYRSA_REQ_EMAIL       "your_email@example.com"
   set_var EASYRSA_REQ_OU         "YourUnit"
   ```

   Далее, создайте корневой сертификат:
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
       ssl_protocols TLSv1.2;
       ssl_ciphers 'YOUR_CIPHER_LIST';
       
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

   Повторите для всех веб-серверов.

2. **Перезапустите Nginx**:
   ```bash
   sudo systemctl restart nginx
   ```

### Этап 5: Проверить конфигурацию

1. **Проверка доступа**:
   Перейдите в браузере на HQ-CLI по HTTPS и убедитесь, что нет предупреждений. Если всё настроено правильно, браузер должен идентифицировать серверы как доверенные.

### Заключение

Следуя этой инструкции, вы сможете настроить собственный центр сертификации с доверительными сертификатами для ваших веб-серверов и перенастроить их на HTTPS без появления предупреждений у клиента. Если возникнут вопросы или сложности, не стесняйтесь их задавать! 
