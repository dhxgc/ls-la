Задать пользователя по умолчанию:
```ini
[user]
default=root
```

---

Указать систему инициализации (должна быть установлена):
> Источник: [Here](https://wiki.gentoo.org/wiki/Gentoo_in_WSL) <br> 
> По умолчанию работает `sysvinit`
 - `systemd`:
```ini
[boot]
systemd = true
```
 - `openrc`:
```ini
[boot]
command = "/sbin/openrc default"
```