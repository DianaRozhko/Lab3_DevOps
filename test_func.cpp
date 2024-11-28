#include <gtest/gtest.h>
#include <cmath>
#include <chrono>
#include "func.h"

// Тест для обчислення гіперболічного синуса при x = 0
TEST(ShFunctionTest, ZeroInput) {
    EXPECT_NEAR(calculateSinh(0.0, 3), 0.0, 1e-6);  // Викликаємо calculateSinh
}

// Тест для позитивного значення x
TEST(ShFunctionTest, PositiveInput) {
    double x = 1.0;
    EXPECT_NEAR(calculateSinh(x, 20), std::sinh(x), 1e-6);  // Викликаємо calculateSinh
}

// Тест для негативного значення x
TEST(ShFunctionTest, NegativeInput) {
    double x = -1.0;
    EXPECT_NEAR(calculateSinh(x, 20), std::sinh(x), 1e-6);  // Викликаємо calculateSinh
}


