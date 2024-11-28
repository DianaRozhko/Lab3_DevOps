#include "func.h"
#include <cmath>  // для використання функції pow
#include <iostream>
#include <vector>
// Функція для обчислення факторіалу
unsigned long long factorial(int n) {
    unsigned long long result = 1;
    for (int i = 2; i <= n; ++i) {
        result *= i;
    }
    return result;
}

// Функція для обчислення гіперболічного синуса
double calculateSinh(double x, int terms) {
    double sum = 0.0;
    for (int n = 0; n < terms; ++n) {
        sum += pow(x, 2 * n + 1) / factorial(2 * n + 1);
    }
    return sum;
}

// Функція для обчислення значень
std::vector<double> calculateValues() {
    std::vector<double> values;
    for (double x = -5.0; x <= 5.0; x += 0.1) {
        values.push_back(calculateSinh(x, 10));  // Викликаємо calculateSinh для кожного значення x
    }
    return values;
}


