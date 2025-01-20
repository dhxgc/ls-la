#!/bin/bash

INSTANCE_COUNT=${INSTANCE_COUNT:-2}
PORT_START=${PORT_START}

# Проверяем наличие IP адресов
for i in $(seq 1 $INSTANCE_COUNT); do
    eval "HOST=\$HOST_$i"  # Используем eval для получения значения переменной окружения
    # Здесь в HOST кладется адрес, указанный в  __ -e HOST_1=10.6.1.61 __

    # Проверяет, задали ли адреса в соответствие с их количеством
    if [ -z "$HOST" ]; then
        echo "Error: HOST_$i is not set!"
        exit 1
    fi

    PORT=$(($PORT_START + i - 1))  # Увеличиваем порт для каждого экземпляра
    /usr/bin/shellinaboxd --no-beep -t --disable-ssl -p $PORT -s /:SSH:$HOST &
    # Запускаем в фоне каждый экземпляр; 
    # -t для http;
    # --disable-ssl чтобы выключить ssl
    # -p порт для web-интерфейса
    # -s конечный хост
    echo "Started Shell In A Box on port $PORT connecting to $HOST"
done

wait