### 1. Завгетил бинарь, распаковал, запустил в фоне
```bash
wget https://github.com/0xJacky/nginx-ui/releases/download/v2.1.6/nginx-ui-linux-64.tar.gz
tar -xzf nginx-ui-linux-64.tar.gz
./nginx-ui
```

### 2. После по `ip:9000` зашел в вебчик, там чек всех файлов. Пофиксил, потыкал кнопочки - пустило
```bash
# 1. Не было файла для обычных логов
touch /var/log/nginx/nginx.log

# 2. Не было директории conf.d/, я просто сделал симлинк на /conf-enabled.d/
ln -s conf-enabled.d/ conf.d

# 3. Аналогичная история с сайтами. Я нажал типа фикс, он просто создал папки. Лучше также сделать симлинки
ln -s sites-enabled.d/ sites-enabled
ln -s sites-available.d/ sites-available
```

