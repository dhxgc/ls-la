> Источник: [Очень простой сервис только с этой уязвимостью](https://github.com/tkmru/nginx-alias-traversal-sample)

Развертывание:
```bash
docker build -t NginxAliasVuln:1
```

Описание:
Получить доступ к флагу, можно просканировав через `NavGix`_[1](https://github.com/hakaioffsec/navgix?ref=labs.hakaioffsec.com). Участник смотрит пути - смотрит, что можно вытащить из доступнх директорий. Ходит по папкам, файлам - находит флаг.