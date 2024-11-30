#include <iostream>
#include <cmath>
#include <cassert>
#include <chrono>
#include "func.h"

// Тест для функції calculateSinh
void testCalculateSinh() {
    int terms = 10;  // Кількість членів ряду Тейлора для обчислення
    double epsilon = 1e-6;  // Допустима похибка

    // Тестові значення x
    double test_values[] = {-2.0, 0.0, 2.0};

    // Початок вимірювання часу
    auto start = std::chrono::high_resolution_clock::now();

    for (double x : test_values) {
        // Очікуваний результат за допомогою стандартної функції sinh
        double expected = std::sinh(x);

        // Результат функції calculateSinh
        double result = calculateSinh(x, terms);

        // Перевірка результату з допустимою похибкою
        assert(fabs(result - expected) < epsilon);

        // Виведення результатів для перевірки
        std::cout << "Test passed for x = " << x << "!" << std::endl;
        std::cout << "Calculated sinh(" << x << ") = " << result << ", expected = " << expected << std::endl;
    }

    // Кінець вимірювання часу
    auto end = std::chrono::high_resolution_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start).count();

    // Перевірка часу виконання
    assert(elapsed >= 5 && elapsed <= 20); // Час повинен бути між 5 і 20 секундами

    // Виведення часу виконання
    std::cout << "Elapsed time: " << elapsed << " seconds" << std::endl;
}

// Тест для функції calculateValues
void testCalculateValues() {
    // Початок вимірювання часу
    auto start = std::chrono::high_resolution_clock::now();

    std::vector<double> values = calculateValues();

    // Кінець вимірювання часу
    auto end = std::chrono::high_resolution_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(end - start).count();

    // Перевірка часу виконання
    assert(elapsed >= 5 && elapsed <= 20); // Час повинен бути між 5 і 20 секундами

    // Перевірка, чи кількість значень є коректною
    assert(values.size() == 101); // Від -5 до 5 з кроком 0.1, тобто 101 значення

    // Перевірка деяких значень
    assert(fabs(values[50] - std::sinh(0.0)) < 1e-6);  // Для x = 0.0
    assert(fabs(values[70] - std::sinh(2.0)) < 1e-6);  // Для x = 2.0

    std::cout << "testCalculateValues passed!" << std::endl;
    std::cout << "Elapsed time: " << elapsed << " seconds" << std::endl;
}

int main() {
    // Запуск тестів
    testCalculateSinh();
    testCalculateValues();

    std::cout << "All tests passed!" << std::endl;
    return 0;
}
