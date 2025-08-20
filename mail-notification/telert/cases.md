# Примеры использования `telert`

1. Увед по завершению команды:
```bash
apt update | telert "Команда завершена!"
```

2. Уведы из скрипта (если вдруг он в несколько этапов, отслеживать что и как):
```bash
#!/bin/bash

export TELERT_TOKEN=""
export TELERT_CHAT_ID=""

if [[ $1 == "bad" ]]; then
        exit 1 | telert "Скрипт ${0} сломался!"
else
        exit 0 | telert "Скрипт ${0} pавершен успешно!"
fi
```

3. 