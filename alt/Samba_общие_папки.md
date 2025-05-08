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
    path = /home/Public
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

2. Для папок с правами на группу:

    2.0 Также создаем папку, выставляем права
    > Могут быть проблемы, если в пути до директории есть другие, с меньшими правами
    ```bash
    mkdir /group1
    ```

    2.1 Узнаем GID требуемой группы на КОНТРОЛЛЕРЕ ДОМЕНА:
    ```bash
    wbinfo --group-info="DOMAIN\group1"
    ```

    2.2 Выставляем права и SGID (чтобы при создании файлов наследовалась группа):
    ```bash
    chmod g+s /group1
    chmod 775 -R /group1
    ```

    2. Выставляем владельца и GID группы из `шага 2.1`:
    ```bash
    chown -R root:<GID> /group1
    ```

    2.1 Добавляем в `smb.conf`:
    ```
    [Group 1]
        path = /group1
        valid users = "@LOCAL\group1" # Группа, для которой создается шара

        writeable = Yes
        browseable = Yes
        read only = No

        create mask = 0664
        directory mask = 0775 # Обязательно 775!!!

        force group = group1
        force create mode = 0664
        force directory mode = 0775
    ```

    2.2 Рестарт самбы:
    ```bash
    systemctl restart samba
    ```