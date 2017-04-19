#include <Windows.h>
#include <tchar.h>
#include <iostream>

struct IXyz {
    virtual int Foo(int n) = 0;
    virtual void Release() = 0;
};

extern "C" IXyz* WINAPI GetXyz();

int _tmain(int /*argc*/, _TCHAR* /*argv*/[])
{
    SetConsoleOutputCP(CP_UTF8);
    _tsetlocale(LC_ALL, _T("utf-8"));
    // 1. COM-like usage.
    IXyz* pXyz = GetXyz();

    if (pXyz) {
        int retval = pXyz->Foo(42);
        std::cout << retval << std::endl;
        pXyz->Release();
    }

    return 0;
}