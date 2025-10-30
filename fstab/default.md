# `fstab` гайдик

### Теория

> [archwiki](https://wiki.archlinux.org/title/Fstab)

#### 1. Устройство
 - указывается путь до устройства:
```text
/dev/sdX
/dev/mdX
...
```
 - указывается UUID ФС устройства:
```text
UUID=2283-F312
```

#### 2. Точка монтирования
 - показывает, куда будет смонтировано устройство:
```text
/mnt/dir
```

#### 3. Файловая система
 - указывается файловая система на устройстве:
```text
btrfs
xfs
ext4
fat32
auto
...
```

#### 4. Параметры
 - общие
 - специфичные для ФС (как, например, `subvol` в `btrfs`)

#### 5. `dump`
> [man here](https://linux.die.net/man/8/dump)
 - проверяет ext2/3 и смотрит, какие файлы надо бэкапнуть. Как правило, всегда установлен в `0`.

#### 6. `fsck`
> [usefull answer](https://superuser.com/questions/247523/fstab-when-do-you-use-the-dump-and-fsck-options)
 - проверяет ФС при загрузке. 
 - Для корневого раздела должна быть `1`. 
 - Указывается "_типа приоритет_" для проверки, поэтому корень обычно ставят в `1`, ___НО НЕ ВСЕГДА!!!___, `btrfs` и `xfs` требует `0`.
```text
0 - отключить проверку
1 - проверить первым
2 - проверять после 1
...
```

---

### Примеры

 - __mount with UUID__
```ini
UUID=2DC5-F631 /boot/efi vfat fmask=0137,dmask=0027 0 2 
```

 - __ext4__
```ini
/dev/sdb2 /mnt/dir ext4 defaults 0 0
```

 - __btrfs subvol__
> `mount -o subvol=@subvol`
```ini
/dev/sdb2 /mnt/dir btrfs subvol=@subvol,noatime,compress=zstd 0 0
```

 - __dir to dir (bind mount):__
> `mount --bind`
```ini
/dir /another/dir auto defaults,bind 0 0
```
