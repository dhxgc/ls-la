# Debian 12 -> Docker -> Rocky9 image


 - Запуск для установки:
docker run --name ipa -it -h ipa.atom25.local --sysctl net.ipv6.conf.all.disable_ipv6=0 -v /sys/fs/cgroup:/sys/fs/cgroup -v ./ipa-data:/data:Z freeipa/freeipa-server:rocky-9
 - Запуск в постоянный режим
docker run --name ipa -it -p 53:53/udp -p 53:53 -p 80:80 -p 443:443 -p 389:389 -p 636:636 -p 88:88 -p 464:464 -p 88:88/udp -p 464:464/udp -p 123:123/udp -h ipa.atom25.local --sysctl net.ipv6.conf.all.disable_ipv6=0 -v /sys/fs/cgroup:/sys/fs/cgroup -v ./ipa-data:/data:Z freeipa/freeipa-server:rocky-9