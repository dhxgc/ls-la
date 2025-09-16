## `Open-RC`
> Источник: [Here](https://docs.alpinelinux.org/user-handbook/0.1a/Working/openrc.html)

 - Запуск, статус, остановка сервиса:
```bash
rc-service <service> start
rc-service <service> status
rc-service <service> stop
```

 - Найти сервис:
```bash
rc-service --list | grep <service>
```

 - Добавить, удалить сервис из автозагрузки:
```bash
rc-update add <service> default
rc-update del <service> default
```

 - Посмотреть сервисы в автозагрузке:
> Справа покажется уровень, на котором грузится сервис
```bash
rc-update show -v
```