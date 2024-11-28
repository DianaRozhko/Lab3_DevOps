#ifndef FUNC_H
#define FUNC_H
#include <vector>
// Функція для обчислення факторіалу
unsigned long long factorial(int n);

// Функція для обчислення гіперболічного синуса
double calculateSinh(double x, int terms);

// Функція для обчислення значень, що використовується в HTTP сервері
std::vector<double> calculateValues();

#endif

