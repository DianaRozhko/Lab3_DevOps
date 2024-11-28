#include <iostream>
#include <cmath>
#include <cassert>
#include "func.h"

void testCalculateValues() {
    std::vector<double> values = calculateValues();

    assert(!values.empty()); // Перевірка, що значення не пусті
    assert(values.front() == sin(0)); // Початкове значення
    assert(values.back() == sin(360 * M_PI / 180.0)); // Останнє значення
    std::cout << "All tests for calculateValues passed!\n";
}

int main() {
    testCalculateValues();
    return 0;
}

