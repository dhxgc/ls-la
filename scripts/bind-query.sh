#!/bin/bash

# ===================================================

# Логика:
# Выбор типа -> Данные для формирования записи -> формирование записи -> закидывание в указанный файд

# Замечания:
# Нет фикса, чтобы не писать ссаные \t и \n

# ===================================================

# Parameters of script
ZONE="/etc/bind/db.zone"
TYPE=$1

# Logic
if [[ "$TYPE" == "A" ]]; then
    RECORD="$2"
    IP="$3"
    echo -e "${RECORD}\tIN\t${TYPE}\t${IP}"

elif [[ "$TYPE" == "CNAME" ]]; then
    RECORD="$2"
    CNAME_DEST="$3"
    echo -e "${RECORD}\tIN\t${TYPE}\t${CNAME_DEST}"

elif [[ "$TYPE" == "PTR" ]]; then
    echo PTR

elif [[ "$TYPE" == "AAAA" ]]; then
    echo AAAA

elif [[ "$TYPE" == "MX" ]]; then
    echo MX

else
    echo Unknown type \"${TYPE}\"
    echo "Usage $0 TYPE parameter1 parameter2"
    exit 1
fi

# Write records in file 
# echo "${RECORD}" >> "${ZONE}"