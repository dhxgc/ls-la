#!/bin/bash

DB_PLACE=""
DB_ADDRESS=""
FRONTEND_PLACE=""
FRONTEND_ADDRESS=""

ZABBIX_USER=
ZABBIX_PASSWD=""
ZABBIX_DATABASE_NAME=""

ZABBIX_FILE="/etc/zabbix/zabbix_server.conf"
PHP_INI="/etc/php/8.2/apache2-mod_php/php.ini"
PSQL_CONF="/var/lib/pgsql/data/postgresql.conf"
PG_HBA_CONF="/var/lib/pgsql/data/pg_hba.conf"

# --------------------------------------------------------------------------------------------------------------- #

# Базовая настройка
echo "DB on this server?: [y/n]"
read -p "> " DB_PLACE
echo "Frontend on this server?: [y/n]"
read -p "> " FRONTEND_PLACE

# Проверка значений
if [[ "${DB_PLACE}" != "y" && "${DB_PLACE}" != "n" ]] || [[ "${FRONTEND_PLACE}" != "y" && "${FRONTEND_PLACE}" != "n" ]];
then
    echo -e "================\nYes or No! Exit.\n================"
    exit 1
fi

# --------------------------------------------------------------------------------------------------------------- #

# Установка БД или скип, если БД на другом сервере
if [[ "${DB_PLACE}" == "y" ]];
then
    echo "==================="
    echo "Install Database..."
    echo "==================="

    echo "Enter the username as well as the DB name: "
    echo "Default: user=zabbix, password=zabbix, database=zabbix"

    read -p "username:      > " ZABBIX_USER
    read -p "user password: > " ZABBIX_PASSWD
    read -p "database:      > " ZABBIX_DATABASE_NAME

    ZABBIX_USER=${ZABBIX_USER:='zabbix'}
    ZABBIX_PASSWD=${ZABBIX_PASSWD:='zabbix'}
    ZABBIX_DATABASE_NAME=${ZABBIX_DATABASE_NAME:='zabbix'}

    apt-get install postgresql16-server zabbix-server-pgsql fping -y

    /etc/init.d/postgresql initdb
    systemctl enable --now postgresql

    su - postgres -s /bin/sh -c "
        psql -c \"CREATE USER \"${ZABBIX_USER}\" WITH ENCRYPTED PASSWORD '${ZABBIX_PASSWD}';\" &&
        createdb -O \"${ZABBIX_USER}\" \"${ZABBIX_DATABASE_NAME}\" &&
        psql -U \"${ZABBIX_USER}\" -f /usr/share/doc/zabbix-common-database-pgsql-*/schema.sql \"${ZABBIX_DATABASE_NAME}\" &&
        psql -U \"${ZABBIX_USER}\" -f /usr/share/doc/zabbix-common-database-pgsql-*/images.sql \"${ZABBIX_DATABASE_NAME}\" &&
        psql -U \"${ZABBIX_USER}\" -f /usr/share/doc/zabbix-common-database-pgsql-*/data.sql \"${ZABBIX_DATABASE_NAME}\"
    "
    apt-get remove zabbix-server-pgsql -y
    apt-get autoclean

    if [[ "${FRONTEND_PLACE}" == "n" ]];
    then
        echo "Enter the IP address of the web server: [192.168.0.100]"
        read -p "> " FRONTEND_ADDRESS

        echo "host    ${ZABBIX_DATABASE_NAME}       ${ZABBIX_USER}          ${FRONTEND_ADDRESS}/32             trust" >> ${PG_HBA_CONF}
        sed -i -E -e "s|^#?(listen_addresses\s*=).*|listen_addresses = '*'|" ${PSQL_CONF}
        systemctl restart postgresql
    fi

else
    echo -e "Enter the IP of the database server: [192.168.0.100]"
    read -p "> " DB_ADDRESS

    echo "Enter the username as well as the DB name: "
    echo "Default: user=zabbix, password=zabbix, database=zabbix"
    read -p "username: > " ZABBIX_USER
    read -p "user password: > " ZABBIX_PASSWD
    read -p "database: > " ZABBIX_DATABASE_NAME

    ZABBIX_USER=${ZABBIX_USER:='zabbix'}
    ZABBIX_PASSWD=${ZABBIX_PASSWD:='zabbix'}
    ZABBIX_DATABASE_NAME=${ZABBIX_DATABASE_NAME:='zabbix'}
fi

# --------------------------------------------------------------------------------------------------------------- #

# Установка Zabbix'a и Frontend'a или скип.
if [[ "${FRONTEND_PLACE}" == "y" ]];
then
    echo "================="
    echo "Install Zabbix..."
    echo "================="

    apt-get install apache2 apache2-mod_php8.2 zabbix-server-pgsql -y
    systemctl enable --now httpd2
    systemctl enable --now zabbix_pgsql

    apt-get install php8.2 php8.2-mbstring php8.2-sockets php8.2-gd php8.2-xmlreader php8.2-pgsql php8.2-ldap php8.2-openssl -y

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

    apt-get install zabbix-phpfrontend-apache2 zabbix-phpfrontend-php8.2 -y

    cp "$ZABBIX_FILE" "${ZABBIX_FILE}.bak_$(date +%d.%m.%Y_%H:%M)"
    if [[ "${DB_PLACE}" == "n" ]];
    then
        sed -i -E \
        -e "s|^#?( DBHost\s*=).*|DBHost=${DB_ADDRESS}|" \
        -e "s|^#?(DBName\s*=).*|DBName=${ZABBIX_DATABASE_NAME}|" \
        -e "s|^#?(DBUser\s*=).*|DBUser=${ZABBIX_USER}|" \
        -e "s|^#?( DBPassword\s*=).*|DBPassword=${ZABBIX_PASSWD}|" \
        -e "s|^?(StatsAllowedIP\s*=).*|StatsAllowedIP=0.0.0.0/0|" \
        "$ZABBIX_FILE"
    else
        sed -i -E \
        -e "s|^#?( DBHost\s*=).*|DBHost=localhost|" \
        -e "s|^#?(DBName\s*=).*|DBName=${ZABBIX_DATABASE_NAME}|" \
        -e "s|^#?(DBUser\s*=).*|DBUser=${ZABBIX_USER}|" \
        -e "s|^#?( DBPassword\s*=).*|DBPassword=${ZABBIX_PASSWD}|" \
        -e "s|^(StatsAllowedIP\s*=).*|StatsAllowedIP=0.0.0.0/0|" \
        "$ZABBIX_FILE"
    fi

    ln -s /etc/httpd2/conf/addon.d/A.zabbix.conf /etc/httpd2/conf/extra-enabled/
    systemctl restart httpd2
    systemctl restart zabbix_pgsql

    chown apache2:apache2 /var/www/webapps/zabbix/ui/conf
else
    echo Zabbix was not installed!
fi
