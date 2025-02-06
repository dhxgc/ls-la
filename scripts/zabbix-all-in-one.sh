#!/bin/bash

# --------------------------------------------------------------------------------------------------------------- #

apt-get install postgresql16-server zabbix-server-pgsql fping -y

/etc/init.d/postgresql initdb
systemctl enable --now postgresql

su - postgres -s /bin/sh -c 'createuser --no-superuser --no-createdb --no-createrole --encrypted --pwprompt zabbix'

su - postgres -s /bin/sh -c 'createdb -O zabbix zabbix'

su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/schema.sql zabbix'
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/images.sql zabbix'
su - postgres -s /bin/sh -c 'psql -U zabbix -f /usr/share/doc/zabbix-common-database-pgsql-*/data.sql zabbix'

# --------------------------------------------------------------------------------------------------------------- #

apt-get install apache2 apache2-mod_php8.2 -y
systemctl enable --now httpd2

apt-get install php8.2 php8.2-mbstring php8.2-sockets php8.2-gd php8.2-xmlreader php8.2-pgsql php8.2-ldap php8.2-openssl -y

PHP_INI="/etc/php/8.2/apache2-mod_php/php.ini"
cp "$PHP_INI" "${PHP_INI}.bak_$(date +%d.%m.%Y_%H:%M)"

sed -i -E \
-e "s|^;?(memory_limit\s*=).*|memory_limit = 256M|" \
-e "s|^;?(post_max_size\s*=).*|post_max_size = 32M|" \
-e "s|^;?(max_execution_time\s*=).*|max_execution_time = 600|" \
-e "s|^;?(max_input_time\s*=).*|max_input_time = 600|" \
-e "s|^;?(date\.timezone\s*=).*|date.timezone = Asia/Yekaterinburg|" \
-e "s|^;?(always_populate_raw_post_data\s*=).*|always_populate_raw_post_data = -1|" \
"$PHP_INI"

systemctl restart httpd2

CONF_FILE="/etc/zabbix/zabbix_server.conf"
cp "$CONF_FILE" "${CONF_FILE}.bak_$(date +%d.%m.%Y_%H:%M)"

sed -i -E \
-e "s|^#?(DBHost\s*=).*|DBHost=localhost|" \
-e "s|^#?(DBName\s*=).*|DBName=zabbix|" \
-e "s|^#?(DBUser\s*=).*|DBUser=zabbix|" \
-e "s|^#?(DBPassword\s*=).*|DBPassword=zabbix|" \
"$CONF_FILE"

systemctl enable --now zabbix_pgsql

apt-get install zabbix-phpfrontend-apache2 zabbix-phpfrontend-php8.2 -y
ln -s /etc/httpd2/conf/addon.d/A.zabbix.conf /etc/httpd2/conf/extra-enabled/
systemctl restart httpd2

chown apache2:apache2 /var/www/webapps/zabbix/ui/conf
