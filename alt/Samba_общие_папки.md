## Samba, общие папки
> Источник: [[Wiki]](https://www.altlinux.org/%D0%9E%D0%B1%D1%89%D0%B8%D0%B5_%D0%BF%D0%B0%D0%BF%D0%BA%D0%B8#%D0%9D%D0%B0%D1%81%D1%82%D1%80%D0%BE%D0%B9%D0%BA%D0%B0_%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D0%B0)

#### Общие папки на КД

1. Для публичной папки, с полными правами для всех

    1.0 Создать папку, накинуть 777 права
    ```bash
    mkdir /home/Public; chmod 777 -R /home/Public 
    ```

    1.1 Добавить в `/etc/samba/smb.conf`:
    ```smb
    [Public]
    path = /home/files
    read only = Yes
    guest ok = Yes
    browseable = yes
    writable = yes
    create mask = 0777
    directory mask = 0777
    ```

    1.2 Рестартнуть самбу:
    ```bash
    systemctl restart samba
    ```

2. Для папок с разными правами:

    1.0 