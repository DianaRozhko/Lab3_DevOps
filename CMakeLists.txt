cmake_minimum_required(VERSION 3.22)  # Вказуємо мінімальну версію CMake

project(Lab3_DevOps)  # Вказуємо назву проекту

# Вказуємо ваші вихідні файли
add_executable(program main.cpp func.cpp)
add_executable(test_program test_func.cpp func.cpp)

# Підключаємо бібліотеки для тестування (якщо вони потрібні)
target_link_libraries(test_program gtest gtest_main)



