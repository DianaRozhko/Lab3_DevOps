#include "func.h"
#include <gtest/gtest.h>
#include <cmath>

// Тест на перевірку результату для x = 0
TEST(ShFunctionTest, ZeroInput) {
    EXPECT_NEAR(sh(0.0), 0.0, 1e-6);
}

// Тест на перевірку результату для x = 1
TEST(ShFunctionTest, PositiveInput) {
    double x = 1.0;
    EXPECT_NEAR(sh(x), std::sinh(x), 1e-6);
}

// Тест на перевірку результату для від'ємного x
TEST(ShFunctionTest, NegativeInput) {
    double x = -1.0;
    EXPECT_NEAR(sh(x), std::sinh(x), 1e-6);
}

// Тест на перевірку результату для великого значення x
TEST(ShFunctionTest, LargeInput) {
    double x = 5.0;
    EXPECT_NEAR(sh(x), std::sinh(x), 1e-6);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

