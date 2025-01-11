> Основной реп, до этого делал по форку какому-то непонятному
>
> `https://github.com/wg-easy/wg-easy/tree/master`
>
> Всякие варики по панелям/скриптам для WG
> 
> `https://habr.com/ru/articles/738890/`

---

Пароль работает только в .env файле, иначе не але =)

В `compose.yml` проброс портов с указанием ip работает только с ip-адресами, dns имена указывать нельзя.

так можно:
```yaml
    ports:
      - "30301:30301/udp"
      - "127.0.0.1:30302:30302/tcp"
```

так нельзя:
```bash
    ports:
      - "30301:30301/udp"
      - "localhost:30302:30302/tcp"
```

---

Посмотреть свой внешний IP на лине:
```bash
wget -qO- ident.me
```

---

Прикол: при объявлении сети в compose файле, все контейнеры которые в ней находится, смогут общаться друг с другом посредством hostname'ов.
То есть, если указан хостнейм при создании контейнера - то можно просто сделать `ping <hostname>`, все будет ок =)

В этом примере nginx и httpd смогут общаться. По `httpd1` и `nginx` соотвественно. 

```yaml
version: '3.9'

name: proxy-and-app

services:
  httpd1:
    image: httpd
    hostname: httpd1

  nginx:
    image: nginx
    hostname: nginx
```

Также, полное доменное имя будет типа: `<имя_контейнера.имя_сети>`. То есть, они могут общаться по:
- имени контейнера (в самом докере, `docker ps -a`)
- полному доменному имени
- hostname'у контейнера

---

Имя проекта в `docker-compose.yml` можно указать через `name:` верхнего уровня:
> https://docs.docker.com/compose/how-tos/environment-variables/envvars/#compose_project_name
```yaml
version: 'тырыпыры'
name: proxy-and-app
тыры пыры
```

---

Самоподписанный серт в nginx:
> https://www.8host.com/blog/samopodpisannyj-ssl-sertifikat-dlya-nginx/?ysclid=m5smnr3v3v465278232

---

- Адрес сети в докере - не изменить (пока не нашел варианта)

  Проще использовать адресацию по именам, она куда удобнее/

  
