#include "func.h"
#include <cmath>
#include <iostream>

// Функція для обчислення факторіала з перевіркою на переповнення
double safeFactorial(int n) {
    unsigned long long result = 1;
    for (int i = 2; i <= n; ++i) {
        result *= i;
        if (result == 0) {  // Перевірка на переповнення
            return -1;  // Повідомлення про переповнення
        }
    }
    return result;
}

// Функція для обчислення гіперболічного синуса
double calculateSinh(double x, int terms) {
    double sum = 0.0;
    for (int n = 0; n < terms; ++n) {
        double term = pow(x, 2 * n + 1)/ safeFactorial(2 * n + 1);
      
        sum += term;
    }
    return sum;
}

// Функція для обчислення значень
std::vector<double> calculateValues(int terms) {
    std::vector<double> values;
    for (int i=1; i <= terms; ++i) {
	   double value=1.0 / safeFactorial(i);
	   values.push_back(value); 
    }
    return values;
}
