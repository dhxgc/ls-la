# VLANы в OVSе

> Работало без, но лучше добавить модуль:
```bash
echo "8021q" >> /etc/modules
```

---

#### Порт в access:
```bash
ovs-vsctl set port ens3 tag=10
```

#### Порт в транк:
```bash
ovs-vsctl set port ens4 trunks=10,20
```