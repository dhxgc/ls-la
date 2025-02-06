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
