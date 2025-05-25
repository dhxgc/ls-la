#!/bin/bash

read -p "Unit name (without .service): " UNIT_NAME
read -p "Path to script or command to run: " COMMAND
read -p "Run after unit (optional, e.g. network.target): " AFTER_UNIT

UNIT_FILE="/etc/systemd/system/${UNIT_NAME}.service"

# Проверка на существование
if [ -f "$UNIT_FILE" ]; then
    echo "Error: Unit $UNIT_FILE already exists."
    exit 1
fi

# Создание systemd unit
cat <<EOF > "$UNIT_FILE"
[Unit]
Description=Custom Unit: $UNIT_NAME
${AFTER_UNIT:+After=$AFTER_UNIT}

[Service]
Type=simple
ExecStart=$COMMAND
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Применение изменений
systemctl daemon-reexec
systemctl daemon-reload

echo "Systemd unit created: $UNIT_FILE"
echo "Enable it using: systemctl enable --now $UNIT_NAME"