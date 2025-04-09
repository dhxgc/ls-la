# Debian 12 -> Docker -> Rocky9 image : ЗАВИСИТ ОТ ВЕРСИИ SYSTEMD

 - Запуск для установки:
```bash
docker run --name ipa -it -h ipa.atom25.local --sysctl net.ipv6.conf.all.disable_ipv6=0 -v /sys/fs/cgroup:/sys/fs/cgroup -v ./ipa-data:/data:Z freeipa/freeipa-server:rocky-9
```
 - Запуск в постоянный режим
```bash
docker run --name ipa -it -p 53:53/udp -p 53:53 -p 80:80 -p 443:443 -p 389:389 -p 636:636 -p 88:88 -p 464:464 -p 88:88/udp -p 464:464/udp -p 123:123/udp -h ipa.atom25.local --sysctl net.ipv6.conf.all.disable_ipv6=0 -v /sys/fs/cgroup:/sys/fs/cgroup -v ./ipa-data:/data:Z freeipa/freeipa-server:rocky-9
```

# Debian 12 -> Podman -> Rocky9 image

 - Предварительно надо настроить `/etc/hosts`:
```hosts
10.0.200.100    ipa.atom25.local ipa
# По аналогии с ALD
```

 - И для установки, и для запуска в постоянку:
```bash
podman run --name ipa -it -h ipa.atom25.local --network host -v /var/lib/ipa-data:/data:Z freeipa/freeipa-server:rocky-9
```

---

 - Сгенерить systemd юнит для управления контейнером:
```bash
podman generate systemd <container-name> > <service-name>.service
mv <service-name>.service /etc/systemd/system/
```