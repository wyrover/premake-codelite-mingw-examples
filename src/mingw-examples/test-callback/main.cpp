#include <iostream>
#include <functional>

// Callback made by me using Template, may have flaws.
// I believe this will translate to more or less the functor below when compiled.
template<typename Function>
void callbackTemplate(Function func)
{
    func;
}

// Callback made by me using Functor, may have flaws.
struct Functor {
    void operator()(void* funct)
    {
        funct;
    };
};

class Fireball
{
public:
    // Normal method
    void hit()
    {
        std::cout << "Been hit by fireball" << std::endl;
    }

    // operator () for class to be able to call it throgh Fireball();
    void operator()()
    {
        std::cout << "Hi, im the fireball class function" << std::endl;
    }
};

// Normal function
void globalFunction()
{
    std::cout << "Global Function" << std::endl;
}

// Since i'm using template and functor here, they need to be a void* it seems.
void *globalFunction2(int i)
{
    std::cout << "Callback: " << i << std::endl;
}

// Same thing as function above without the *, to show usage of function pointer.
void globalFunction3(void *, int i)
{
    std::cout << "Callback: " << i << std::endl;
}

// main
int main()
{
    std::function<void()> callbackFunction;
    // Calls global function.
    callbackFunction = &globalFunction;
    callbackFunction();
    // Callback to Fireball{};
    callbackFunction = Fireball{};
    callbackFunction();
    // Callback made by me using template.
    callbackTemplate(globalFunction2(5));
    // Callback using functor
    Functor functor;
    functor(globalFunction2(6));
    // Function pointer - For some reason after searching online, they ask to use void * in the first parameter to pass "state" whatever they mean.
    void(*qwe)(void *, int);
    //void(*qwe)(int);
    qwe = globalFunction3;
    qwe(7);
    // Callback to fireball.hit(); using Lambda.
    Fireball fireball;
    callbackFunction = [&]() {
        fireball.hit();
    };
    callbackFunction();

    // Playing around with the function pointer.
    for (int i = 0; i < 10; i++)
        qwe(i);

    return 0;
}
