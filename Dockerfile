# Базовий образ
FROM gcc:latest

# Створення робочої директорії
WORKDIR /server

# Копіювання всіх файлів у контейнер
COPY . /server

# Компіляція програми
RUN apt-get update && apt-get install -y g++ make build-essential
RUN ls -la /server
RUN chmod +x ./server
ENTRYPOINT ["./server"]
