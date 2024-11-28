# Базовий образ
FROM gcc:latest

# Створення робочої директорії
WORKDIR /app

# Копіювання всіх файлів у контейнер
COPY . /app

# Компіляція програми
RUN g++ -o server HTTP_Server.cpp func.cpp mainServer.cpp -lpthread

# Вказівка на порт для прослуховування
EXPOSE 8081

# Запуск сервера
CMD ["./server"]
