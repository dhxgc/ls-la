# `BTRFS`

> Source: [Here](https://habr.com/ru/companies/veeam/articles/458250/)

Все данные делятся на 3 типа:
 - `Data`
 - `Metadata`
 - `System` 

Для каждого из типа применяется свой ___профиль записи___:
 - `Single`
 - `DUP`
 - `RAIDX`

---

<details><summary>

### Первая попытка - создание, монтирование, просмотр томов

</summary>

> Source: [Here](https://fedoramagazine.org/working-with-btrfs-subvolumes/)

![alt text](/images/btrfs/btrfs-test1.png)

---

 - btrfs в `fstab`:
```config
# BTRFS
UUID=1c40a313-ec78-4987-bcae-19e9bdca7dff       /btrfs  btrfs   defaults        0       0
# SUBVOLUME
UUID=1c40a313-ec78-4987-bcae-19e9bdca7dff       /etc/static  btrfs   defaults,subvolid=261        0       0
```

 - Просмотр всех томов:
> `-o` - только вложенные тома
```bash
btrfs subvolumes list .
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
</details>

---

<details><summary>

### Вторая попытка - снапшоты

</summary>

 - Снапшот - такой же подтом.
 - Можно использовать как замену хардлинкам.
 - Не просто копирует файлы, а ТОЛЬКО ИЗМЕНЕНИЯ. По итогу экономит место.
 - Бэкапятся только файлы/директории. Все вложенные тома - ___игнорируются.___
 - `compsize .` (из btrfs-compsize) - покажет, сколько занято реально/сколько заняло бы при простом копировании.

<details><summary><b>Нюанс - снапшот только для чтения</b></summary>
Сохранять снапшот на один и тот же диск не всегда целесообразно. Чтобы его забэкапить на другой диск, нужно использовать такую конструкцию:

```bash
# Сделать снапшот на диске в RO
btrfs subvolume snapshot -r org snp-ro
# Отправить снапшот на другой диск
btrfs send snp-ro | btrfs recieve /backup-drive/
```
</details><br>

---

<details><summary>

 - Создать снапшот:
</summary>

> `-r` - снапшот только для чтения.
```bash
btrfs subvolume snapshot org snp-1
```
</details>


<details><summary>

 - Отправить снапшот в файл:
</summary>

```bash
btrfs send snp-ro -f /some/path/snp-ro.btrfs
```
</details>


<details><summary>

 - Отправить только изменения между томами (актуально при отправке на другой диск/в файл):
</summary>

```bash
# Другой диск
btrfs send -p snp-1-ro snp-2-ro | btrfs recieve /backup-drive/
# Файл
btrfs send -p snp-1-ro snp-2-ro -f /some/path/snp-34-diff.btrfs
```
</details>



<details><summary>

 - Восстановить из снапшота:
</summary>

1. ___Если снапшот на другом диске___ - ПЕРЕЙТИ В НЕГО, отправить на основную ФС (будь то `/` или `/btrfs`, как в данном случае):
```bash
cd /backup-drive
btrfs send snp-ro | btrfs recieve /btrfs/
```
2. Скопировать снапшот вместо изначального тома:
```bash
btrfs subvolume snapshot snp-ro org
```
</details>

<details><summary>

 - Восстановить из снапшота (файла):
</summary>

1. Скопировать том из образа:
```bash
btrfs receive -f /backup-drive/snp-ro.btrfs
```

2. Скопировать снапшот вместо изначального тома:
```bash
btrfs subvolume snapshot snp-ro org
```
</details>

</details>