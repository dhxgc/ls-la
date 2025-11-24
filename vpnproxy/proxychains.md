### Кратко про `proxychains`

#### Минимальный рабочий конфиг:
```ini
strict_chain
quiet_mode
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5 89.169.36.109 1080
```

---

#### Режимы:
- `dynamic_chain` - используется каждый сервер в порядке указания в конфиге. Падает один сервер - он скипается;
- `strict_chain` - создается цепочка в виде `user-1-2-n-some.site`. Падает один сервер, падает вся цепочка;
- `round_robin_chain` - по идее, циклическая балансировка, не уверен;
- `random_chain` - просто создается рандомная цепочка.

---

#### Длина цепочки:
Определяет длину цепочки. Если указано 1 - будет цепочка из одного сервера.<br>То есть `user - [1/2/n] - site`. Если 2 - будет `user - [1/2/n] - [1/2/n] - site`. <br>Работает при режимах `round_robin` и `random`.
```ini
chain_len = 1
```

---

#### Режимы DNS:
> Описание того, как именно работает перехват DNS - [Here](https://security.stackexchange.com/questions/224394/how-does-proxychains-avoid-dns-leaks)
- `proxy_dns` - подменяет ответы, работа описана в комментарии выше
- `proxy_dns_old` - резолвит как-то через скрипты, не вникал, не использовал
- `proxy_dns_daemon 127.0.0.1:1053` - тоже самое, что и в первом варианте, но с использованием отдельного демона.

---

#### Список прокси:
Указывается в разделе `[ProxyList]`:
```ini
[ProxyList]
socks5  127.0.0.1 8888 user password
socks4  127.0.0.1 8888 user password
http    127.0.0.1 8888 user password
https   127.0.0.1 8888 user password
```

---

#### Кейсы:
##### Запуск chrome и chromium:
> Важный момент: при запуске нескольких экземпляров, потом будет создаваться просто дочерний процесс для старого хрома. Из-за этого `proxychains` ниче перехватывать не будет, нужно все позакрывать к чертям
 - Нужно расскомментировать эту строчку (используем третий вариант):
```ini
proxy_dns_daemon 127.0.0.1:1053
```

 - Запустить резолвер для перехвата DNS запросов:
```bash
root# proxychains4-daemon
```

 - Запустить приложение:
```bash
root# proxychains4 google-chrome-stable --no-sandbox
root# proxychains4 chromium --no-sandbox --in-process-gpu
```

 - Итоговая конфига:
```ini
random_chain
chain_len = 1
proxy_dns_daemon 127.0.0.1:1053
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5 127.0.0.1 8888
```

##### Firefox:
 - Ему хватает просто `dns_proxy`:
```ini
random_chain
chain_len = 1
proxy_dns
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5 127.0.0.1 8888
```