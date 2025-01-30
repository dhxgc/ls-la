# Источники
> https://www.altlinux.org/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0_%D0%B8_%D0%BF%D0%B5%D1%80%D0%B2%D0%BE%D0%BD%D0%B0%D1%87%D0%B0%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F_%D0%BD%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_ZABBIX
# Установка

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
- --encrypted - пароль зашифрован;
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
