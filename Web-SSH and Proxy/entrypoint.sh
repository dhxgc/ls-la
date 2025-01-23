#!/bin/bash

PORT_START=${PORT_START:-4200}
i=1

# Проверяем наличие IP адресов
while true; do
    HOST_VAR="HOST_$i"
    HOST=${!HOST_VAR}

    # Проверяет, задали ли адреса в соответствие с их количеством
    if [ -z "$HOST" ]; then
        break
    fi

    PORT=$(($PORT_START + i - 1))  # Увеличиваем порт для каждого экземпляра
    /usr/bin/shellinaboxd --no-beep -t --disable-ssl -p $PORT -s /:SSH:$HOST &
    # Запускаем в фоне каждый экземпляр; 
    # -t для http;
    # --disable-ssl чтобы выключить ssl
    # -p порт для web-интерфейса
    # -s конечный хост
    echo "Started Shell In A Box on port $PORT connecting to $HOST --static-file=styles.css:/etc/shellinabox/shellinabox.css"

    i=$(($i + 1))
done

wait