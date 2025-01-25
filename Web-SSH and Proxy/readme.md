# Multi WEB-SSH

---

Запуск:
```sh
docker run -itd --rm \ 
    -p 4200-4201:4200-4201 \ 
    -e INSTANCE_COUNT=2 \
    -e PORT_START=4200 \ 
    -e HOST_1=10.6.1.61 \ 
    -e HOST_2=10.6.1.62 \ 
    test:4
```

---

Переменные:
 - INSTANCE_COUNT - количество хостов
 - PORT_START - начальный рот для web-доступа
 - HOST_1/2/3 - адрес конечного устройства для подключения