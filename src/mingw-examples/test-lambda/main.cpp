#include <iostream>
#include <vector>
#include <algorithm> // for_each

// Functor to display entered number.
struct functor {
    void operator()(int number)
    {
        std::cout << number << std::endl;
    }
};

// Function using a functor to display an array of numbers.
void func(std::vector<int> &v)
{
    // Need to instantiate it first.
    functor f;
    std::for_each(v.begin(), v.end(), f);
}

// Function using a lambda to display an array of numbers.
void funcLambda(std::vector<int> &v)
{
    // The & inside brackets signifies that the expression will be able to access variables in the current scope.
    std::for_each(v.begin(), v.end(), [&](int number) {
        std::cout << number << std::endl;
    });
}

// main function
int main()
{
    // Init Vector
    std::vector<int> v;
    v.push_back(4);
    v.push_back(6);
    v.push_back(8);
    v.push_back(10);
    // Call foreach for functor.
    func(v);
    // breakline for readability
    std::cout << std::endl;
    // Call foreach using lambda instead of functor.
    funcLambda(v);
    return 0;
}
