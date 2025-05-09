Полезные команды для самбы:

1. Посмотреть UID/GID, почти всегда выполняется на КД 
> Источник: [[Документация, чисто по `wbinfo`]](https://docs.altlinux.org/ru-RU/domain/10.4/html/samba/wbinfo.html#)
```bash
    wbinfo --group-info="DOMAIN\group_name"
    wbinfo --user-info="DOMAIN\user_name"
```