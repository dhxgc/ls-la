#!/bin/bash

# === README ===
# Если в пробросе указан eth0 - то только пакетики с линка на eth0 пробросятся.
# Если с клиента в LAN обратиться на АДРЕС eth0 - работать не будет. 
# Это работает именно на ФИЗИЧЕСКИЙ интерфейс, а не на его IP.
# ===============

mkdir -p /etc/rules_manager/

# Файл для хранения добавленных правил
RULE_FILE="/etc/rules_manager/iptables_rules.txt"
COMMENT_FILE="/etc/rules_manager/iptables_rule_comments.txt"

# Функция для добавления правила
add_rule() {
    read -p "Введите интерфейс (например, eth0): " interface
    read -p "Введите порт обращения: " src_port
    read -p "Введите адрес, на который будет перенаправлено: " dest_ip
    read -p "Введите порт назначения: " dest_port
    read -p "Введите комментарий для правила: " comment

    # Добавляем правило DNAT для перенаправления
    iptables -t nat -A PREROUTING -i "$interface" -p tcp --dport "$src_port" -j DNAT --to-destination "$dest_ip:$dest_port"
    iptables -A FORWARD -p tcp -d "$dest_ip" --dport "$dest_port" -j ACCEPT

    # Сохраняем информацию о добавленном правиле в файл
    echo "$interface $src_port $dest_ip $dest_port" >> "$RULE_FILE"
    echo "$comment" >> "$COMMENT_FILE"
    echo "Правило добавлено: $src_port -> $dest_ip:$dest_port через $interface"
}

# Функция для вывода правил, добавленных через скрипт
list_rules() {
    echo "Текущие правила DNAT, добавленные через скрипт:"
    if [ -f "$RULE_FILE" ]; then
        # Читаем все правила
        mapfile -t rules < "$RULE_FILE"
        mapfile -t comments < "$COMMENT_FILE"

        for i in "${!rules[@]}"; do
            rule="${rules[$i]}"
            comment="${comments[$i]}"
            echo "$((i + 1))) $rule - Комментарий: ${comment:-Нет комментария}"
        done
    else
        echo "Нет добавленных правил."
    fi
}

# Функция для удаления правила
delete_rule() {
    list_rules
    read -p "Введите номер правила для удаления (0 для выхода): " rule_number
    if [[ "$rule_number" == "0" ]]; then
        return
    fi

    # Получаем детали правила из файла
    line=$(sed -n "${rule_number}p" "$RULE_FILE")
    if [ -z "$line" ]; then
        echo "Неверный номер правила."
        return
    fi

    # Извлекаем данные из строки
    read -r interface src_port dest_ip dest_port <<< "$line"

    # Удаляем правило из iptables
    if iptables -t nat -D PREROUTING -i "$interface" -p tcp --dport "$src_port" -j DNAT --to-destination "$dest_ip:$dest_port" 2>/dev/null; then
        echo "Правило DNAT удалено."
    else
        echo "Правило DNAT не найдено, возможно оно уже было удалено."
    fi

    # Удаляем правило ACCEPT из цепочки FORWARD
    if iptables -D FORWARD -p tcp -d "$dest_ip" --dport "$dest_port" -j ACCEPT 2>/dev/null; then
        echo "Правило ACCEPT удалено."
    else
        echo "Правило ACCEPT не найдено, возможно оно уже было удалено."
    fi

    # Удаляем правило из файлов
    sed -i "${rule_number}d" "$RULE_FILE"
    sed -i "${rule_number}d" "$COMMENT_FILE"
}

# Главное меню
while true; do
    echo "Выберите действие:"
    echo "1) Добавить правило"
    echo "2) Показать правила"
    echo "3) Удалить правило"
    echo "4) Выход"
    read -p "Ваш выбор: " choice

    case "$choice" in
        1) add_rule ;;
        2) list_rules ;;
        3) delete_rule ;;
        4) exit 0 ;;
        *) echo "Недопустимый выбор. Пожалуйста, попробуйте снова." ;;
    esac
done
