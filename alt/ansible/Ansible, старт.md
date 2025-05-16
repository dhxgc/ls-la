# Первый опыт в Ansible
> Источник: [[Wiki]](https://www.altlinux.org/Ansible#%D0%9E%D0%B1_Ansible)

Установка:
```bash
# Сервер
apt-get install ansible openssh -y

# Клиент
apt-get install python python-module-yaml python-module-jinja2 python-modules-json python-modules-distutils openssh -y
```

После нужно поправить `/etc/openssh/sshd_config`, чтобы можно было логиниться от рута

Работает все через `ssh`. Нужно сгенерить ключи на клиенте и сервере, закинуть публичный ключ сервера на все клиенты:
```bash
# На сервере
cat .ssh/id_rsa.pub | ssh root@client "cat >> ~/.ssh/authorized_keys"
```

> Проверить можно через `ssh root@client`, не должно быть запроса пароля

После надо создать список со всеми хостами в `/etc/ansible/hosts`:
```yml
[all:vars]
ansible_user=root

[client]
192.168.122.11
```

Проверка:
```
[root@ansible ~]# ansible -m ping client
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details
192.168.122.11 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python2.7"
    },
    "changed": false,
    "ping": "pong"
}
```

Базовый `ansible` готов.