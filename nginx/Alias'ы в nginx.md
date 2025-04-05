# __alias__ в nginx'e

Чтобы сделать небольшой прикол, когда сайт доступен не из корня, а из нужного расположения (https://10.6.1.62/web/), есть alias'ы.

`/etc/nginx/conf.d/default.conf`:
```nginx
server {
        listen 80;
        server_name 10.6.1.62;

        location /web {
                alias /var/www/html/;
                try_files $uri $uri/ /index.html; # По идее - необязательно
                index index.html; # По идее - необязательно
        }
}
```

Если указывать root вместо alias - не работает. Связано это с принципом работы директивы `root`. 
> Подробнее: https://qna.habr.com/q/78932
