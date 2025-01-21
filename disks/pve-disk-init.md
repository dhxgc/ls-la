> Источники:
>
> `https://losst.pro/komanda-fdisk-v-linux` - про `fdisk`
>
> `https://www.dmosk.ru/miniinstruktions.php?mini=linux-fstab` - про `fstab`
>
> `https://losst.pro/montirovanie-diska-v-linux` - про `mount` в линукс, лучше скипать и сразу в `fstab` добавлять
>
fdisk /dev/sdb

параметр `g` для создания новой пустой GPT-таблицы

параметр `n` для создания нового раздела

указывается номер тома

указывается с какого сектора диска начинается раздел

указывается каким сектором кончается разел

параметр `w` чтобы выйти и сохранить

mkfs.ext4 /dev/sdb1

mkdir /stand

nano /etc/fstab

/dev/sdb1 /stand

systemctl daemon-reload

mount -a 

lsblk

![image](https://github.com/user-attachments/assets/a3e1e2d5-e6cf-4bd4-9d40-1be7145f2a4e)


storage -> add -> Directory -> id любой, директорию в которую маунтится
