#ifndef HTTP_SERVER_H
#define HTTP_SERVER_H

#include <string>

// Основні HTTP-заголовки
const std::string HTTP_200 = "HTTP/1.1 200 OK\r\n";
const std::string HTTP_404 = "HTTP/1.1 404 Not Found\r\n";
const std::string HTTP_400 = "HTTP/1.1 400 Bad Request\r\n";

// Прототипи функцій
int CreateHTTPserver();
void sendGETresponse(int fd, const char *response);

#endif

