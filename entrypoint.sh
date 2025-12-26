#!/bin/sh

# Проверяем, есть ли переменная PROXY_USERS
if [ -z "$PROXY_USERS" ]; then
    echo "Error: PROXY_USERS environment variable is not set."
    exit 1
fi

# Создаем пользователей из списка
for user_pair in $PROXY_USERS; do
    username=${user_pair%%:*}
    password=${user_pair#*:}

    # Проверяем, существует ли пользователь, если нет - создаем
    if id "$username" >/dev/null 2>&1; then
        echo "User $username already exists, updating password."
        echo "$username:$password" | chpasswd
    else
        echo "Creating user: $username"
        adduser -D -g '' "$username"
        echo "$username:$password" | chpasswd
    fi
done

echo "Starting Dante SOCKS server..."
# Запускаем Dante в фоновом режиме или просто exec (чтобы он стал PID 1)
exec sockd -f /etc/sockd.conf
