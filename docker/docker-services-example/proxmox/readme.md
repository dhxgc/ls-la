# `pve` в докере


 - Запуск:
```yaml
services:
  proxmoxve:
    hostname: "pve"
    container_name: pve
    image: rtedpro/proxmox:9.0.11
    ports:
      - 8006:8006
    privileged: true
```
```bash
docker run -itd --name pve --hostname pve -p 8006:8006 --privileged rtedpro/proxmox:9.0.11
```

 - Создание сети, подключение:
```bash
sudo docker network create \
--driver bridge \
--subnet=192.168.1.0/24 \
eth2

docker network connect eth2 pve
```

 - Создание бриджа в контейнере:
```bash
docker exec -it proxmoxve bash

for i in $(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | sed 's/@.*//'); do echo -e "auto $i\niface $i inet manual\n" >> /etc/network/interfaces; done
```