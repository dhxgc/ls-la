 - Запуск - желательно в композе

 - `docker-compose.yml`
```yml
services:
  dhcp-server:
    image: dhxgc/dhcp-server
    network_mode: host
    volumes:
      - ./data/dhcpd.conf:/etc/dhcp/dhcpd.conf
    command: dhcpd ens18 -d -4 -f
```

 - `dhcpd.conf`:
```conf
subnet 10.0.200.0 netmask 255.255.255.0 {
   range 10.0.200.110 10.0.200.200;
   option domain-name-servers 10.0.200.100, 8.8.8.8;
   option domain-name "atom25.local";
   option routers 10.0.200.1;
   option broadcast-address 10.0.200.255;
   default-lease-time 600;
   max-lease-time 7200;
}
```

Примечания:
 - в `command: ` нужно написать свои сетевые интерфейсы
 - флаги нужно оставлять по умолчанию, иначе он не запускается в фоне