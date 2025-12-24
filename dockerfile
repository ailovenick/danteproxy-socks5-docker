FROM wernight/dante

# Переключаемся на root, чтобы иметь права создавать пользователей
USER root

# 1. Создаем пользователей (флаг -D в Alpine значит "без пароля", пароль задаем следом)
# Синтаксис: echo "user:password" | chpasswd

RUN adduser -D -g '' user
RUN echo "proxy_user:password" | chpasswd

# 2. Копируем наш кастомный конфиг, где включена авторизация
COPY sockd.conf /etc/sockd.conf

# Dante запускается от пользователя root, чтобы читать /etc/passwd, 
# но потом сбрасывает права (если настроено). 
# В этом образе entrypoint ожидает работу от root для старта.
USER root

