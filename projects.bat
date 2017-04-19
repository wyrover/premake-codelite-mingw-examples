cd /d "%~dp0"
set PATH=%~dp0;%PATH%
premake5 --file=premake-codelite-mingw-examples.lua codelite x86
replace_project_str.vbs
pause