#include <iostream>

int main() {
    int *t = (int *)malloc(100);
    std::cout << "Hello, World!" << std::endl;
    std::cout << t[100] << std::endl;
    return 0;
}
