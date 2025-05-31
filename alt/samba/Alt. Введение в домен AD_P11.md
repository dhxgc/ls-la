> Источник: [[Документация, большая]](https://www.altlinux.org/ActiveDirectory/Login#%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0_%D0%BF%D0%B0%D0%BA%D0%B5%D1%82%D0%BE%D0%B2)
## Ввод через GUI
Самый простой способ добавить альт в домен - через ЦУС (Alterator, в консоли - `acc`).

Для начала поставить модули для alterator'a для аутентификации:
```bash
apt-get install alterator-auth-ad -y
```

Если зайти сейчас, то он скажет, что модули для аутентификации в системе не установлены. Ставим:
```bash
apt-get install task-auth-ad-{sssd,winbind} -y
# Или по простому
apt-get install task-auth-ad-sssd task-auth-ad-winbind -y
```

___Перед входом в домен выставляем в качестве DNS сервера адрес нашего КД.___

Теперь можно снова зайти в Alterator. Пользователи --> Аутентификация. Выбираем Домен Active Directory, в нем можно указать только имя домена. Входим, радуемся.

---

## Ввод через CLI

Ставим пакеты:
```bash
apt-get install alterator-auth-ad task-auth-ad-{sssd,winbind} -y
```

Расскомменчиваем запись для рута в `/etc/sudoers`, а еще ___выставляем DNS'ы___
> Команда `system-auth` доступна только через sudo, бред епта

Вводим в домен:
```bash
sudo system-auth write ad local.gns.domain host-150 local 'administrator' 'P@ssw0rd' [--windows2008] [--winbind] [--gpo] [-d]
```

---

## `su` и `sudo` новым пользователям

Чтобы разрешить ВСЕМ пользовтелям использовать su/sudo, нужно на ___клиентском ПК___:
 - Добавить "сопоставление" доменной группы и роли:
```bash
roleadd 'domain users' localadmins
```