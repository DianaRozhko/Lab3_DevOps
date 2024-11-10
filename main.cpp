#include <iostream>
#include "func.h"

int main() {
    double x;
    int terms;

    std::cout << "Enter the value of x: ";
    std::cin >> x;
    std::cout << "Enter the number of terms: ";
    std::cin >> terms;

    double result = calculateSinh(x, terms);
    std::cout << "sh(" << x << ") ≈ " << result << std::endl;

    return 0;
}

