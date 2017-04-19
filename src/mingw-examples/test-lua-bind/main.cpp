#include <Windows.h>
#include <iostream>
#include <kaguya/kaguya.hpp>

int luaopen_hello_lua_module(lua_State* L);

void hello_cpp_world()
{
    std::cout << "hello cpp world" << std::endl;
}

void hello()
{
    std::cout << "invoke by lua" << std::endl;
}

void test_string_fun(std::string a, std::string  b)
{
    std::cout << a << ":" << b << std::endl;
}


int main()
{
    SetConsoleOutputCP(CP_UTF8);
    using namespace kaguya;
    State state;
    state.dostring("print('hello lua world')");
    state["hello_cpp_world"] = &hello_cpp_world;//bind function
    state.dostring("hello_cpp_world()");
    luaopen_hello_lua_module(state.state());
    state["hello"] = &hello;
    state["test_string_fun"] = &test_string_fun;
    state.dofile("script.lua");
    system("PAUSE");
}





int luaopen_hello_lua_module(lua_State* L)
{
    using namespace kaguya;
    State state(L);
    LuaTable module = state.newTable();
    module["hello"] = kaguya::function(&hello);
    return module.push();
}
