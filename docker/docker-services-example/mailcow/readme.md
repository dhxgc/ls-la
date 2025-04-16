> Источник: [[Ссылка]](https://unixhost.pro/blog/ru/2022/10/mailcow-nastraivaem-sobstvennyj-pochtovyj-server/)
## `Mailcow` в Docker'е

### Минимальное развертывание:

0. Поднимал на ALT'е, в Docker'е, этот пункт скипнул. В мануале просят установить `docker-compose-plugin`.

1. Склонировать реп, запустить скрипт
```bash
git clone https://github.com/mailcow/mailcow-dockerized && cd mailcow-dockerized
./generate_config.sh
```
> Дальше пойдут интерактивные вопросики
> 
> Домен - писал не просто домен, а добавлял в начало `mail`, чтобы было типа - `mail.atom25.local`
> 
> Ну и запись для `mail.atom25.local` в BIND'е тоже сделал

2. ...