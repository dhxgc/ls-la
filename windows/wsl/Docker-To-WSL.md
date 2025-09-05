### Как я перекинул образ `alpine` из докера в WSL

> Source: [\<HERE\>](https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro)

1. Запустить контейнер, в нем можно че-нить базовое установить и сразу протестить, чтобы потом в WSL'е не ебаться.
```bash
docker run -itd alpine sh
# apk update
# apk add ...
```

2. Экспортнул в `.tar`:
> Не знаю, почему не через `--output`, я не тестил
```bash
docker export alpine > /mnt/c/Users/admin/WSL/templates/alpine.tar
```

3. Добавил в WSL:
```powershell
wsl --import AlpineLinux C:\Users\admin\WSL\AlpineLinux C:\Users\admin\WSL\templates\alpine.tar --vhd
```

---

### Преднастрой самого `Alpine` для норм работы

1. Пакетики:
> `shadow` - для `chsh`; `sudo` - чтобы не юзать `su`
```bash
apk add nano bash bash-completion \ 
    shadow sudo
```

2. Настроечка:
```bash
adduser admin
echo "admin ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
echo -e "[user]\ndefault=admin" > /etc/wsl.conf
chsh -s /bin/bash

su - admin
echo "cd ~" > /home/admin/.profile
```

3. Дополнительное (шрифты, PATH):
```bash
# PATH (WSL, PowerShell, system32)
echo "export PATH=$PATH:/mnt/c/Windows/system32/:/mnt/c/Program\ Files/:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Users/admin/AppData/Local/Microsoft/WindowsApps/" >> ~/.profile

# Шрифты для бразуеров и прочего
apk add font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra font-liberation
```