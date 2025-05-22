# BONDы в OVSе

Добавить Bond:
```bash
ovs-vsctl add-bond br0 bond0 ens3 ens4
```

Выставить режим:
```bash
ovs-vsctl set port bond0 lacp=active
```

Посмотреть как дела у бонда:
```bash
ovs-appctl lacp/show
```