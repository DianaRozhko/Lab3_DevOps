#include <iostream>
#include "HTTP_Server.h"

int main() {
    try {
        if (CreateHTTPserver() != 0) {
            std::cerr << "Failed to start the server." << std::endl;
            return 1;
        }
    } catch (const std::exception &ex) {
        std::cerr << "Exception occurred: " << ex.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "An unknown error occurred." << std::endl;
        return 1;
    }

    return 0;
}

