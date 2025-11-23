> Docs - [[1]](https://docs.kernel.org/admin-guide/bcache.html)<br>
> Old arch wiki - [[2]](https://wiki.archlinux.org/title/Bcache#Device_or_resource_busy)<br>
> New arch wiki - [[3]](https://wiki.archlinux.org/title/Talk:Bcache)

> bcache mods - [[4]](https://wiki.ubuntu.com/ServerTeam/Bcache)
---

#### Почистить backing-устройство (`/dev/md127`):
```bash
echo 1 > /sys/class/block/bcache0/bcache/stop

# Должна быть запись об остановке устройства
dmesg

# Почистить метаданные bcache (также сработало создание таблицы MBR на этом устройстве)
wipefs -a /dev/md127
```

Почистить caching-устройство (/dev/sda):
```bash
echo 1 > /sys/fs/bcache/<UUID>/unregister
wipefs -a /dev/sda
```

---

 - Кратко:
```bash
make-bcache --wipe-bcache -B /dev/md127 -C /dev/sdd

# Посмотреть состояние всех компонентов
cat /sys/block/bcache0/bcache/state

# Посмотреть текущий режим работы кеша
cat /sys/block/bcache0/bcache/cache_mode
```