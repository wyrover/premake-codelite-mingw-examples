# premake-codelite-mingw-examples

通过 premake5.exe 生成的 codelite 工程，如是动态库链接选项有转义符
```
-shared;-Wl,--out-implib=\"../../bin/DevCppDLL.lib\";-static
```

改为

```
-shared;-Wl,--out-implib="../../bin/DevCppDLL.lib";-static

```

编译通过

提供了一个 replace_project_str.vbs 来替换生成工程的字符串


**生成 32 位工程**

直接执行 projects.bat

```
premake5 --file=premake-codelite-mingw-examples.lua codelite x86
replace_project_str.vbs
```

**生成 64 位工程**

```
premake5 --file=premake-codelite-mingw-examples.lua codelite x64
replace_project_str.vbs
```