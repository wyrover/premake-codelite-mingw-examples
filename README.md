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


## 链接库的问题

Codelite 不要求写后缀 ".lib"，但是 Visual Studio 要求写后缀 ".lib"。

生成的 liblua-s.lib 改成 liblua-s 也链接不了，不知为什么 Codelite 生成的 make 改名为 lua-s
暂且生成 lua-static-s.lib ，引用为 lua-static-s