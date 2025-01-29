Установка БД + fping:
```
apt-get install postgresql16-server zabbix-server-pgsql fping
```
Создание системных БД:
```
/etc/init.d/postgresql initdb
```
Включаем автозагрузку pgsql:
```
systemctl enable --now postgresql
```
Создаем юзера zabbix:
```
su - postgres -s /bin/sh -c 'createuser --no-superuser --no-createdb --no-createrole --encrypted --pwprompt zabbix'
```
Параметры:
- --no-superuser - не является суперпользователем;
- --no-createdb - не может создавать новые БД;
- --no-createrole - не может создавать новые роли;
- --encrypted - шифрует пароль;
- --pwprompt - просит ввести пароль следующей командой.

Создаем БД zabbix:
```
su - postgres -s /bin/sh -c 'createdb -O zabbix zabbix'
```

Генерируем шаблоны для БД zabbix скриптами:
```
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/schema.sql zabbix'
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/images.sql zabbix'
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/data.sql zabbix'
```

Ставим апачи:
```
apt-get install apache2 apache2-mod_php8.2
```

Включаем автозагрузку pgsql:
```
systemctl enable --now httpd2
```

Ставим все нужные расширения для корректной работы zabbix:
```
apt-get install php8.2 php8.2-mbstring php8.2-sockets php8.2-gd php8.2-xmlreader php8.2-pgsql php8.2-ldap php8.2-openssl
```

В файле `/etc/php/8.2/apache2-mod_php/php.ini` ищем и меняем следующие строки:
```
memory_limit = 256M
post_max_size = 32M
max_execution_time = 600
max_input_time = 600
date.timezone = Asia/Yekaterinburg
always_populate_raw_post_data = -1
```

Перезагружаем апачи:
```
systemctl restart httpd2
```

Далее в файле `/etc/zabbix/zabbix_server.conf` найти и поменять строки:
```
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
```

Включаем автозагрузку zabbix-сервера с pgsql:
```
systemctl enable --now zabbix_pgsql
```


```
apt-get install zabbix-phpfrontend-apache2 zabbix-phpfrontend-php8.2
```

Включаем аддоны в апачи:
```
ln -s /etc/httpd2/conf/addon.d/A.zabbix.conf /etc/httpd2/conf/extra-enabled/
```

Перезагружаем:
```
service httpd2 restart
```

Даем права пользователю на папку со всем вебом апачи:
```
chown apache2:apache2 /var/www/webapps/zabbix/ui/conf
```

Далее переходим по адресу `http://ip/zabbix`, проверяем предварительные условия и производим первоначальную настройку. 
По ip/zabbix получается перейти благодаря строке 'Alias' в `/etc/httpd2/conf/addon.d/A.zabbix.conf`.
Важная вещь, весь интерфейс zabbix находится в `/var/www/webapps/zabbix/ui`, а конкретно эта первоначальная настройка пишется в файл `/var/www/webapps/zabbix/ui/conf/zabbix.conf.php`, где как раз имеются:
- настройки БД;
- TLS соединения;
- способа хранения данных;
- имени сервера.

Данные для входа после окончания первоначальной настройки:
```
Логин: Admin
Пароль: zabbix
```


Папка `/etc/httpd2/conf/addon.d` (или `/etc/apache2/conf/addon.d` в зависимости от дистрибутива) используется в веб-сервере Apache для хранения дополнительных конфигурационных файлов, которые могут быть динамически подключены к основной конфигурации Apache. Это позволяет администраторам легко добавлять или изменять настройки сервера без необходимости редактирования основных конфигурационных файлов, таких как `httpd.conf` или `apache2.conf`.

---
---
---

deepseek:

### Принцип действия `addon.d` в Apache2

1. **Модульность конфигурации**:
   - Apache поддерживает модульную структуру конфигурации. Это означает, что конфигурация может быть разделена на несколько файлов, которые подключаются в основной конфигурации с помощью директив `Include` или `IncludeOptional`.
   - Папка `addon.d` обычно используется для хранения таких модульных конфигурационных файлов.

2. **Динамическое подключение конфигураций**:
   - В основном конфигурационном файле Apache (например, `apache2.conf` или `httpd.conf`) может быть указана директива, которая включает все файлы из папки `addon.d`. Например:
     ```apache
     IncludeOptional /etc/apache2/conf/addon.d/*.conf
     ```
   - Это позволяет Apache автоматически подключать все файлы с расширением `.conf` из папки `addon.d` при запуске или перезагрузке сервера.

3. **Удобство управления**:
   - Администраторы могут добавлять, удалять или изменять конфигурационные файлы в папке `addon.d`, не затрагивая основные конфигурационные файлы. Это упрощает управление настройками сервера, особенно в средах, где несколько человек или систем могут вносить изменения.
   - Например, можно создать отдельный файл для настройки виртуальных хостов, модулей или других параметров.

4. **Пример использования**:
   - Предположим, у вас есть несколько виртуальных хостов, и вы хотите управлять их конфигурациями отдельно. Вы можете создать файл `vhosts.conf` в папке `addon.d` и поместить туда конфигурацию для каждого виртуального хоста. Apache автоматически подключит этот файл при следующей перезагрузке.

5. **Порядок загрузки**:
   - Файлы в папке `addon.d` обычно загружаются в алфавитном порядке. Это важно, если конфигурации зависят друг от друга. Например, если один файл определяет переменные, которые используются в другом файле, порядок загрузки может повлиять на корректность работы сервера.

6. **Пример содержимого папки `addon.d`**:
   - В папке `addon.d` могут находиться файлы с такими именами, как:
     - `ssl.conf` — настройки SSL/TLS.
     - `security.conf` — настройки безопасности, такие как ограничение доступа.
     - `mod_rewrite.conf` — настройки модуля `mod_rewrite`.
     - `custom_vhosts.conf` — пользовательские виртуальные хосты.

### Пример файла в `addon.d`

Пример файла `ssl.conf` в папке `addon.d`:

```apache
<IfModule mod_ssl.c>
    Listen 443
    <VirtualHost *:443>
        ServerAdmin webmaster@example.com
        DocumentRoot /var/www/html
        ServerName example.com

        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/example.com.crt
        SSLCertificateKeyFile /etc/ssl/private/example.com.key

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
</IfModule>
```

Этот файл настраивает SSL для виртуального хоста и будет автоматически подключен Apache при перезагрузке.

### Заключение

Папка `addon.d` в Apache2 — это удобный способ организации дополнительных конфигурационных файлов. Она позволяет администраторам легко управлять настройками сервера, разделяя их на логические части и избегая необходимости редактирования основных конфигурационных файлов. Это особенно полезно в крупных и сложных конфигурациях, где требуется гибкость и модульность.
