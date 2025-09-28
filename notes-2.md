# `BTRFS`

> Source: [Here](https://habr.com/ru/companies/veeam/articles/458250/)

Все данные делятся на 3 типа:
 - `Data`
 - `Metadata`
 - `System` 

Для каждого из типа применяется свой ___профиль записи___:
 - `single`
 - `DUP`
 - `RAIDX`

---

<details><summary>

### Первая попытка - создание, монтирование, просмотр томов

</summary>

> Source: [Here](https://fedoramagazine.org/working-with-btrfs-subvolumes/)

![alt text](/images/btrfs/btrfs-test1.png)

---

Просмотр всех томов:
```bash
btrfs subvolumes list .
# только дочерние тома
btrfs subvolumes list -o .
```

<details><summary>Пояснения по выводу:</summary>

```bash
root@debian:/btrfs$ btrfs subvolume list /etc/dirforsubsub 
ID 261 gen 24 top level 5 path dll
ID 262 gen 22 top level 261 path dll/subsub
root@debian:/btrfs$ mount -o subvolid=262 /dev/sdb1 /etc/dirforsubsub/
root@debian:/btrfs$ 
```
 - `ID` - идишник каждого сабволюма, по нему можно также монтировать
 - `gen` - версия/поколение сабволюма, служебное и я в это не вдавался
 - `level` - `ID` родительского тома (сам корневой раздел (который на `/dev/sdb1`) всегда имеет ID = 5, то есть по факту тоже является сабволюмом, но нигде это не афишируется)

</details>

<details>
<summary>Нюансы, детали:</summary>
<br>

> При работе с подтомами (монтирование, удаление и тп) стоит понимать, что это не просто директории, а именно подтома. Их также можно монтировать, бэкапить и тп. Поэтому в командах, в которых идет обращение к `subvolume` мы пишем именно его название, а не просто путь к нему. Если же это вложенный subvolume - то пишем родительский, а после дочерний subvolume. Хорошо это объясняется тем, что вместо имени подтома мы можем написать просто его `id`.


</details>