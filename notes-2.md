# `BTRFS`

> Source: [Here](https://habr.com/ru/companies/veeam/articles/458250/)

Все данные делятся на 3 типа:
 - `Data` - пользовательские данные
 - `Metadata` - не разобрался, что-то типа "служебное" для работы `Data`
 - `System` - вроде как 

Для каждого из типа применяется свой ___профиль записи___:
 - `single` - обычное хранение в единственном экземпляре
 - `DUP` - дублирование на ___одном___ носителе
 - `RAIDX` - 

---
<details><summary>

### Тесты, тыканье

</summary>

#### Сделать subvolume, смонтировать его
> Source: [Here](https://fedoramagazine.org/working-with-btrfs-subvolumes/)

![alt text](/images/btrfs/btrfs-test1.png)

Дано:
 - `/dev/sdb`, на нем `/dev/sdb1|2`
 - `/dev/sdb1` смонтирован в `/btrfs`
 - вся система в `ext4`, в единственном разделе

Шаг 1:
 - Сделан подтом ___dll___ - `btrfs subvolume create dll`
 - Подтом ___dll___ смонтирован в `/etc/static`

```bash
btrfs subvolume create dll
mount -o subvol=dll /dev/sdb1 /etc/static
```

<details><summary></summary>
some text
</details>