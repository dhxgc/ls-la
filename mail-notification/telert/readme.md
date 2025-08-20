# `telert`
> Источник: [[здесь]](https://github.com/navig-me/telert/tree/main)

### Установка:
1. `pipx install telert` - наиболее простая
2. `docker pull ghcr.io/navig-me/telert` - в докере

---

### Инициализация/Настройка
0. Узнать `id` чата, куда слать уведомления:
```bash
curl https://api.telegram.org/bot<TOKEN>/getUpdates
```
> Можно искать сразу по `"title":"название_чатика"` - если это конфа. Если личка с ботом - то искать по `"username":"тег_в_телеге"`. В каждом варике рядом будет `"chat":{"id"`, там и есть айдишник.

1. Заинитить интерактивно:
```bash
telert init
```

2. Протестировать:
```bash
telert run echo 'Hello, telert!'
```