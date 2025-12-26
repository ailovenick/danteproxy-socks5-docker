FROM wernight/dante

USER root

# Копируем конфиг
COPY sockd.conf /etc/sockd.conf

# Копируем скрипт запуска и даем права на исполнение
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Указываем, что при старте нужно выполнить наш скрипт
ENTRYPOINT ["/entrypoint.sh"]