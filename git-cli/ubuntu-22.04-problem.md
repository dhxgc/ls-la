# Поебень с ssh на ебаной убунте

> [1] - https://www.reddit.com/r/github/comments/tcck0q/git_ssh_problem/?tl=ru

___Проблема___ - `git` не работает по ssh, вообще никак, просто отказывается. `https` работает четко

___Решение___ - добавить в `~/.ssh/config` запись:
```ssh
Host github.com
        Hostname ssh.github.com
        Port 443
        User git
        IdentityFile ~/.ssh/id_rsa
        IdentitiesOnly yes
```

Дополнительные шаги, которые были сделаны (хз, повлияли ли они):
 - Ключ сделан заново с указанием почты - ` ssh-keygen -o -t rsa -C "akruasanov@gmail.com"`
