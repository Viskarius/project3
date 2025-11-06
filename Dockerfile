FROM nginx:alpine

# Копируем нашу игру
COPY index.html /usr/share/nginx/html/

# Копируем кастомный конфиг nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Создаем необходимые директории для nginx с правильными правами
RUN mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/run/nginx && \
    chown -R nginx:nginx /var/cache/nginx /var/run/nginx && \
    chmod -R 755 /var/cache/nginx /var/run/nginx

# Переключаемся на пользователя nginx
USER nginx

# Открываем порт
EXPOSE 8080

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
