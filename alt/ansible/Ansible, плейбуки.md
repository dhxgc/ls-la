# Плейбуки в Ansible
> Источник: [[Wiki]](https://www.altlinux.org/Ansible#%D0%9E%D0%B1_Ansible)

Примеры:

```yaml
# govno.yml
- hosts: ansible-client
  remote_user: root
  tasks: 
  - name: Shell Test
    shell: echo govno > ansible.a
```

```bash
ansible-playbook govno.yml
```

