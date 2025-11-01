# Переустановка `grub2` с `efi`

> Source: [Here](https://askubuntu.com/questions/831216/how-can-i-reinstall-grub-to-the-efi-partition)

Это подойдет в случае:
 - если при установке был скипнут пункт с установкой загрузчика
 - раздел пизданулся, система не бутается

Кратко:
> `sdX` = disk | `sdXX` = efi partition | `sdXY` = system partition
```bash
sudo mount /dev/sdXY /mnt
sudo mount /dev/sdXX /mnt/boot/efi 

for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done  

sudo chroot /mnt

mount -t efivarfs none /sys/firmware/efi/efivars
grub-install /dev/sdX
update-grub
exit
```