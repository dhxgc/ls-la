#!/bin/bash
set -e

# Клонируем репозиторий, если не существует
if [ ! -d "/data/.git" ]; then
  git clone --depth 1 "$GIT_REPO" /data -b Samba-Network-Alt
fi

# Запускаем сервер
exec python simple_server.py --dir /data --port 8000
