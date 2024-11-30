#include <gtest/gtest.h>
#include <chrono>
#include "HTTP_Server.cpp"  // Ваш код сервера

// Тест для перевірки часу виконання функції handleComputeRequest
TEST(ComputeTimeTest, TestComputationTime) {
    // Підготовка
    int dummySocket = 0;  // Використовуємо фіктивний сокет

    // Початок вимірювання часу
    auto start = std::chrono::high_resolution_clock::now();

    // Викликаємо функцію, яка повинна обчислити час виконання
    handleComputeRequest(dummySocket);

    // Кінець вимірювання часу
    auto end = std::chrono::high_resolution_clock::now();

    // Розрахунок тривалості в мілісекундах
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);

    // Перевірка, що час виконання знаходиться в межах від 5000 до 20000 мс (від 5 до 20 секунд)
    EXPECT_GE(duration.count(), 5000);  // Час повинен бути більше або рівний 5000 мс
    EXPECT_LE(duration.count(), 20000); // Час повинен бути менше або рівний 20000 мс
}

int main(int argc, char **argv) {
    // Ініціалізація Google Test
    ::testing::InitGoogleTest(&argc, argv);
    
    // Запуск тестів
    return RUN_ALL_TESTS();
}
