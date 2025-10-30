# `os-prober` не обнаруживает системы с корнем на `btrfs`

Решение 1:
 - Зашел на последнюю систему, смонтировал корневой раздел (в `btrfs` сам диск, не `@` том) первой системы
 - Открыл `<some-path>/boot/grub/grub.cfg`
 - В нем нашел три записи: основная загрузочная, и сабменю с двумя записями внутри
 - Скопировал их и вставил в `/etc/grub.d/40_custom`
 - Обновил загрузчик (`update-grub`)

Сами записи из `grub.cfg`:
> При попытке взять только первую запись (основную), `update-grub` сказал, что я еблан
```config
menuentry 'EndeavourOS Linux' --class endeavouros --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-c39471d8-9d79-4392-80e4-262ef8bb15a5' {
        load_video
        set gfxpayload=keep
        insmod gzio
        insmod part_gpt
        insmod btrfs
        set root='hd1,gpt2'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd1,gpt2 --hint-efi=hd1,gpt2 --hint-baremetal=ahci1,gpt2  c39471d8-9d79-4392-80e4-262ef8bb15a5
        else
          search --no-floppy --fs-uuid --set=root c39471d8-9d79-4392-80e4-262ef8bb15a5
        fi
        echo    'Loading Linux linux ...'
        linux   /@/boot/vmlinuz-linux root=UUID=c39471d8-9d79-4392-80e4-262ef8bb15a5 rw rootflags=subvol=@  nowatchdog nvme_load=YES resume=UUID=d47d16e3-a182-427b-94c9-0957c01b203c loglevel=3
        echo    'Loading initial ramdisk ...'
        initrd  /@/boot/initramfs-linux.img
}
submenu 'Advanced options for EndeavourOS Linux' $menuentry_id_option 'gnulinux-advanced-c39471d8-9d79-4392-80e4-262ef8bb15a5' {
        menuentry 'EndeavourOS Linux, with Linux linux' --class endeavouros --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-advanced-c39471d8-9d79-4392-80e4-262ef8bb15a5' {
                load_video
                set gfxpayload=keep
                insmod gzio
                insmod part_gpt
                insmod btrfs
                set root='hd1,gpt2'
                if [ x$feature_platform_search_hint = xy ]; then
                  search --no-floppy --fs-uuid --set=root --hint-bios=hd1,gpt2 --hint-efi=hd1,gpt2 --hint-baremetal=ahci1,gpt2  c39471d8-9d79-4392-80e4-262ef8bb15a5
                else
                  search --no-floppy --fs-uuid --set=root c39471d8-9d79-4392-80e4-262ef8bb15a5
                fi
                echo    'Loading Linux linux ...'
                linux   /@/boot/vmlinuz-linux root=UUID=c39471d8-9d79-4392-80e4-262ef8bb15a5 rw rootflags=subvol=@  nowatchdog nvme_load=YES resume=UUID=d47d16e3-a182-427b-94c9-0957c01b203c loglevel=3
                echo    'Loading initial ramdisk ...'
                initrd  /@/boot/initramfs-linux.img
        }
        menuentry 'EndeavourOS Linux, with Linux linux (fallback initramfs)' --class endeavouros --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-linux-fallback-c39471d8-9d79-4392-80e4-262ef8bb15a5' {
                load_video
                set gfxpayload=keep
                insmod gzio
                insmod part_gpt
                insmod btrfs
                set root='hd1,gpt2'
                if [ x$feature_platform_search_hint = xy ]; then
                  search --no-floppy --fs-uuid --set=root --hint-bios=hd1,gpt2 --hint-efi=hd1,gpt2 --hint-baremetal=ahci1,gpt2  c39471d8-9d79-4392-80e4-262ef8bb15a5
                else
                  search --no-floppy --fs-uuid --set=root c39471d8-9d79-4392-80e4-262ef8bb15a5
                fi
                echo    'Loading Linux linux ...'
                linux   /@/boot/vmlinuz-linux root=UUID=c39471d8-9d79-4392-80e4-262ef8bb15a5 rw rootflags=subvol=@  nowatchdog nvme_load=YES resume=UUID=d47d16e3-a182-427b-94c9-0957c01b203c loglevel=3
                echo    'Loading initial ramdisk ...'
                initrd  /@/boot/initramfs-linux-fallback.img
        }
}
```

Решение 2:
 - При установке системы создавать еще один раздел - монтировать в /boot с ext4
 - То есть итоговый вариант должен выглядеть как:
```bash
[user@eos ~]$ lsblk -f
sdb                                                                                      
├─sdb1      vfat   FAT32             2DC5-F631                                 2G     0% /boot/efi
├─sdb2      ext4                     <some-uuid>                               4G     5% /boot
├─sdb3      btrfs        endeavouros c39471d8-9d79-4392-80e4-262ef8bb15a5   96,4G    10% /var/log
│                                                                                        /var/cache
│                                                                                        /home
│                                                                                        /
└─sdb4      swap   1     swap        d47d16e3-a182-427b-94c9-0957c01b203c                [SWAP]
```