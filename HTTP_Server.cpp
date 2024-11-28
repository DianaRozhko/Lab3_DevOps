#include <iostream>
#include <vector>
#include <chrono>
#include <algorithm>
#include <cstring>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/sendfile.h>
#include <sys/socket.h>
#include "func.h" // функції для обчислень

#define PORT 8081

void sendGETresponse(int fd, const char *response);
int CreateHTTPserver();

int CreateHTTPserver() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);

    // Створення сокету
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Socket failed");
        exit(EXIT_FAILURE);
    }

    // Налаштування сокету
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        perror("Setsockopt failed");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Прив'язка сокету
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    // Очікування підключення
    if (listen(server_fd, 3) < 0) {
        perror("Listen failed");
        exit(EXIT_FAILURE);
    }

    while (true) {
        printf("Waiting for connection...\n");

        if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t *)&addrlen)) < 0) {
            perror("Accept failed");
            exit(EXIT_FAILURE);
        }

        char buffer[30000] = {0};
        read(new_socket, buffer, 30000);

        // Перевірка запиту
        if (strncmp(buffer, "GET /compute", 12) == 0) {
            // Вимірювання часу
            auto start = std::chrono::high_resolution_clock::now();

            // Виклик функції для обчислень
            std::vector<double> values = calculateValues(); // calculateValues - функція з `func.cpp`
            std::sort(values.begin(), values.end());

            auto end = std::chrono::high_resolution_clock::now();
            auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

            // Формування відповіді
            std::string response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n";
            response += "Computation completed in " + std::to_string(duration) + " ms\n";
            response += "Sorted values: ";
            for (double value : values) {
                response += std::to_string(value) + " ";
            }

            sendGETresponse(new_socket, response.c_str());
        } else {
            const char *notFound = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nInvalid request.";
            sendGETresponse(new_socket, notFound);
        }

        close(new_socket);
    }

    close(server_fd);
    return 0;
}

void sendGETresponse(int fd, const char *response) {
    write(fd, response, strlen(response));
}

