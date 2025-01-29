```
apt-get install postgresql16-server zabbix-server-pgsql fping
```

```
/etc/init.d/postgresql initdb
```

```
systemctl enable --now postgresql
```

```
su - postgres -s /bin/sh -c 'createuser --no-superuser --no-createdb --no-createrole --encrypted --pwprompt zabbix'
```

```
su - postgres -s /bin/sh -c 'createdb -O zabbix zabbix'
```

```
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/schema.sql zabbix'
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/images.sql zabbix'
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/data.sql zabbix'
```

```
apt-get install apache2 apache2-mod_php8.2
```

```
systemctl enable --now httpd2
```

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

```
systemctl enable --now zabbix_pgsql
```

```
apt-get install zabbix-phpfrontend-apache2 zabbix-phpfrontend-php8.2
```

```
ln -s /etc/httpd2/conf/addon.d/A.zabbix.conf /etc/httpd2/conf/extra-enabled/
```

```
service httpd2 restart
```

```
chown apache2:apache2 /var/www/webapps/zabbix/ui/conf
```

Далее переходим по адресу http://`ip`/zabbix, проверяем предварительные условия и производим первоначальную настройку. 

Важная вещь, весь интерфейс zabbix находится в `/var/www/webapps/zabbix/ui`, а конкретно эта первоначальная настройка пишется в файл `/var/www/webapps/zabbix/ui/conf/zabbix.conf.php`, где как раз имеются:
- настройки БД;
- TLS соединения;
- способа хранения данных;
- имени сервера.
```

```
