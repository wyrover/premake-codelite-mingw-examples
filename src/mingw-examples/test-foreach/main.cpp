#include <iostream>
#include <vector>

int main()
{
    std::vector<int> ints;
    ints.push_back(9);
    ints.push_back(10);
    ints.push_back(11);
    ints.push_back(12);
    ints.push_back(13);

    // Print before
    for (auto& i : ints) {
        std::cout << i << '\n';
    }

    std::cout << '\n';

    // Add 1 to each element
    for (auto& i : ints) {
        i += 1;
    }

    // Print after
    for (auto& i : ints) {
        std::cout << i << '\n';
    }

    return 0;
}