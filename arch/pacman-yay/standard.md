### `pacman`

 - Установить:
```bash
pacman -S пакет
```

 - Обновить систему:
```bash
pacman -Suy
```

 - Удалить пакет:
```bash
pacman -Rns пакет
```

 - Посмотреть подробную инфу о пакете:
```bash
pacman -Qi пакет
```

 - Посмотреть осиротевшие пакеты:
```bash
pacman -Qdt
```

 - Удалить все осиротевшие пакеты:
```bash
pacman -Rns $(sudo pacman -Qtdq)
```

---

### `yay`

 - Установить `yay`:
```bash
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

> Юзает `AUR` в качестве исходников. При установке самостоятельно собирает указанное ПО, прям через `makefile` и тп

 - Установить пакет:
```bash
yay -S пакет
```

 - Удалить пакет:
```bash
yay -D пакет
```