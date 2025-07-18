### TCP и UDP балансировка

---

### 1. Пробросить порт
> [1] - [Ссылка на фрагмент из документации](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/#:~:text=%D0%BA%D0%BE%D1%82%D0%BE%D1%80%D1%83%D1%8E%20%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%20%D0%BF%D0%B5%D1%80%D0%B5%D0%BD%D0%B0%D0%BF%D1%80%D0%B0%D0%B2%D0%BB%D1%8F%D0%B5%D1%82-,%D1%82%D1%80%D0%B0%D1%84%D0%B8%D0%BA%3A,-%D0%9A%D0%BE%D0%BF%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D1%82%D1%8C)

Конфига:
```nginx
# /etc/nginx/nginx.conf

# Проброс 2222 на 22 порт целевого сервера
stream {
    server {
        listen 2222;
        proxy_pass 192.168.122.201:22;
    }

# Проброс для UDP (ДНС просто для проверки)
    server {
        listen 127.0.0.1:53 udp;
        proxy_pass 8.8.8.8:53;
    }
}
```

Сразу ___нюанс___ - это не сработает в виртуальных хостах, так как они включаются в корневой блок `http {...}` в `nginx.conf`.

Чтобы все работало, нужно добавлять конфиги или напрямую в `nginx.conf`, или в `modules-enabled/` (100% в Debian-like, названия с `.conf`)

Кратко:
 - Добавляем корневой блок `stream`, который отвечает за TCP и UDP.
 - Указываем, куда перенаправлять

Детали:
 - Для UDP нужно добавлять udp - `listen 53 udp`.

---

### 2. Проброс на апстрим серверов

> Источник тот же

Конфига:
```nginx
# /etc/nginx/nginx.conf

stream {
    upstream cluster {
        server 192.168.122.201:22;
        server 192.168.122.202:22;
    }
    server {
        listen 2222;
        proxy_pass cluster;
    }
}
```

Кратко:
 - Также `stream {}`, в него апстримы и конфиги для пробросов

Детали:
 - Здесь как я понял область видимости как у переменных, и `stream` в душе не ебет какие там апстримы у `http {}`, поэтмоу пришлось их перенести в сам стрим.
 - Порты у серверов надо указывать сразу в апстриме, потому что оно слишком умное и понимает, что порт в `proxy_pass cluster:22` избыточен. В общем - описанное в конфиге работает и делать лучше так.