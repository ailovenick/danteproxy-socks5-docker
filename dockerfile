FROM wernight/dante

# Переключаемся на root, чтобы иметь права создавать пользователей
USER root

# Получаем список пользователей из docker-compose (.env)
ARG PROXY_USERS

# Цикл по всем пользователям (разделитель - пробел)
RUN for user_pair in $PROXY_USERS; do \
      # Получаем имя (все до двоеточия)
      username=${user_pair%%:*}; \
      # Получаем пароль (все после двоеточия)
      password=${user_pair#*:}; \
      # Создаем пользователя
      adduser -D -g '' "$username"; \
      # Устанавливаем пароль
      echo "$username:$password" | chpasswd; \
    done

# 2. Копируем наш кастомный конфиг, где включена авторизация
COPY sockd.conf /etc/sockd.conf

# Dante запускается от пользователя root, чтобы читать /etc/passwd, 
# но потом сбрасывает права (если настроено). 
# В этом образе entrypoint ожидает работу от root для старта.
USER root

