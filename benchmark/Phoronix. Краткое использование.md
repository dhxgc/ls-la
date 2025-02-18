> Источник: [Статья по этому делу](https://habr.com/ru/companies/cloud4y/articles/596833/)

`Phoronix` нужен для тестов системы всякими-всякими тестами. 

Точно есть под линь, под винду наверное тоже. Можно тестить вообще все компоненты системы, в том числе тестами всякого ПО (nginx, apache).

Установить:
> Debian
```bash
apt update && apt install php-gd curl git sqlite3 bzip2 php-cli php-xml -y && git clone https://github.com/phoronix-test-suite/phoronix-test-suite.git && cd phoronix-test-suite && ./install-sh
```
> Альт - по идее есть в репах, искать там =)

---

Минимальное нужное использование:
```bash
phoronix-test-suite list-available-tests     # Покажет все доступные тесты
phoronix-test-suite benchmark pts/tiobench   # Установить и запустить выбранный тест (из команды выше)
phoronix-test-suite install pts/hadoop       # Только установить указанный тест
phoronix-test-suite run pts/hadoop           # Запустить выбранный тест (уже установленный)
```
