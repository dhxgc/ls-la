#!/bin/bash

# =====================================================

# Autogenerate crontab tasks and ssh connect for rsync backup

# Rsync server
RSYNC_SERVER="root@192.168.122.10"
# For dir on server (/backup/srv-2)
CLIENT_NAME="srv-2"
# Dirs to backup
SRC_DIRS=("/etc" "/home" "/opt/data")
# Every 5m, for test
CRON_TIME="*/5 * * * *"
# Place of public key
SSH_KEY="$HOME/.ssh/id_rsa"

# =====================================================

if [[ ! -f "$SSH_KEY" || ! -f "$SSH_KEY.pub" ]]; then
    echo "Cant find keys, use: ssh-keygen"
    exit 1
fi

### === KEY TO SERVER ===

echo "Add ssh-key to $RSYNC_SERVER"
ssh-copy-id -i "$SSH_KEY.pub" "$RSYNC_SERVER" || {
    echo "Can't add key to the host"
    exit 1
}

### === CREATE RSYNC COMMAND ===

RSYNC_LINE="rsync -az --delete ${SRC_DIRS[*]} $RSYNC_SERVER:/backup/$CLIENT_NAME/"

### === CRON ===

TMP_CRON=$(mktemp)
crontab -l 2>/dev/null | grep -v "$RSYNC_SERVER.*$CLIENT_NAME" > "$TMP_CRON"
echo "$CRON_TIME $RSYNC_LINE" >> "$TMP_CRON"
crontab "$TMP_CRON"
rm "$TMP_CRON"

echo "Backup Completed: $RSYNC_LINE"
