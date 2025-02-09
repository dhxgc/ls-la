# Новый диск в `Proxmox'e`

> Источники:
>
> `https://losst.pro/komanda-fdisk-v-linux` - про `fdisk`
>
> `https://www.dmosk.ru/miniinstruktions.php?mini=linux-fstab` - про `fstab`
>
> `https://losst.pro/montirovanie-diska-v-linux` - про `mount` в линукс, лучше скипать и сразу в `fstab` добавлять


Чтобы создать/удалить разделы, переопределить GPT/MBR, использовать `fdisk`:
```bash
fdisk /dev/sdb

# параметр `g` для создания новой пустой GPT-таблицы
# параметр `n` для создания нового раздела
# -->
    # указывается номер тома
    # указывается с какого сектора диска начинается раздел
    # указывается каким сектором кончается разел
# <--
# параметр `w` чтобы выйти и сохранить
```

Форматнуть раздел:
```bash
mkfs.ext4 /dev/sdb1
```

Добавить диск для автомонтирования, при запуске системы:
```bash
echo "" >> /etc/fstab
```

Ребут и перечитывание всех конфигов всеми сервисами:
```bash
systemctl daemon-reload
```
Монтирование всего из `fstab`:
```bash
mount -a 
```

Проверить диски и их директории:
> `lsblk -f` покажет тоже самое, но и файловые системы, UUID, а также занятость дисков.
```bash
lsblk
```
Добавить новый диск в самом PVE:

Datacenter --> Storage --> Add --> Directory

![image](https://github.com/user-attachments/assets/a3e1e2d5-e6cf-4bd4-9d40-1be7145f2a4e)

