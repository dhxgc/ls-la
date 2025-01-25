> Источник:
>
> https://github.com/tobarod/netee/blob/main/clintFile/secoclient-linux-64-7.0.2.26.run

### Установка

```bash
wget https://github.com/tobarod/netee/raw/refs/heads/main/clintFile/secoclient-linux-64-7.0.2.26.run
bash secoclient-linux-64-7.0.2.26.run
```

---

### Запуск

- Находится по пути `/usr/local/SecoClient/`.
- `SecoClientSC` Позволяет запускать SecoClient из консоли, там же подключаться.

1. Если графика, то смотреть в менюхе, в зависимости от ОС.
2. Если CLI, то хз. 
3. Добавить SecoClient в PATH:
```bash
PATH="$PATH:/usr/local/SecoClient/"
# До конца сессии
```
```bash
if [ -d "/usr/local/SecoClient" ] ; then
  PATH="$PATH:/usr/local/SecoClient/"
fi
```