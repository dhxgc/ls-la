> Источники: [[1]](https://docs.github.com/en/repositories/working-with-files/managing-large-files/configuring-git-large-file-storage)

# Использование Git Large File Storage

1. Установить Git LFS
```bash
# Debian 12
apt install git-lfs
```

> Нужен уже готовый репизориторий, в котором можно коммитить/пушить и тд

2. Добавить большие для отслеживания:
```bash
# Если несколько файлов
git lfs track "*.tar"
# Один файл
git lfs track file.tar
```

3. Дальше работа как с обычным репозиторем
```bash
# Добавляем все, вместе с большим файлом
git add --all 
git commit -m "Add large file"
git push
```