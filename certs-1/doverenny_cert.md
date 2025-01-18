Чтобы сделать самоподписанные сертификаты доверенными в браузере на Debian с использованием Nginx, вам нужно выполнить несколько шагов. Вот пошаговая инструкция:

1. **Создание корневого сертификата**:
   Если вы еще не создали корневой сертификат, выполните следующие команды:
   ```bash
   openssl genrsa -out rootCA.key 2048
   openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem
   ```
   Вы будете запрашиваться ввести информацию о вашем сертификате, такую как страна и организацию.

2. **Создание сертификата для вашего домена**:
   Замените `<your_domain>` на ваш действительный домен.
   ```bash
   openssl req -new -newkey rsa:2048 -nodes -keyout <your_domain>.key -out <your_domain>.csr -subj "/CN=<your_domain>"
   openssl x509 -req -in <your_domain>.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out <your_domain>.crt -days 365 -sha256
   ```

3. **Добавление сертификата в доверенные**:
   - Скопируйте корневой сертификат в каталог для доверенных сертификатов:
     ```bash
     sudo cp rootCA.pem /usr/local/share/ca-certificates/rootCA.crt
     ```

   - Обновите доверенные сертификаты:
     ```bash
     sudo update-ca-certificates
     ```

4. **Настройка Nginx**:
   В файле конфигурации Nginx укажите пути к вашему сертификату и ключу:
   ```nginx
   server {
       listen 443 ssl;
       server_name <your_domain>;
       ssl_certificate /path/to/<your_domain>.crt;
       ssl_certificate_key /path/to/<your_domain>.key;
   
       location / {
           root /path/to/your/web/files;
           index index.html index.htm;
       }
   }
   ```
   Не забудьте перезагрузить Nginx после изменения конфигурации:
   ```bash
   sudo systemctl restart nginx
   ```

5. **Импорт сертификата в браузер**:
   - **Для Firefox**: Просто откройте файл `rootCA.pem` и добавьте его как доверенный.
   - **Для Chrome**: Откройте настройки, перейдите в "Безопасность" → "Управление сертификатами" → "Доверенные корневые центры сертификации" и импортируйте `rootCA.pem`.

После выполнения этих шагов браузер должен воспринимать ваше соединение как безопасное и не выдавать предупреждений о недоверенных сертификатах.

Если вам потребуется использовать самоподписанные сертификаты в разных браузерах или системах, проверьте каждую на наличие необходимости дополнительного импорта сертификатов, так как процесс может варьироваться в зависимости от платформы. 
