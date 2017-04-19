print(_ARGS[1])

workspace "mingw-examples"
    language "C++"
    location ("build/%{_ACTION}/" .. _ARGS[1])
    targetdir "bin"
    flags { "StaticRuntime", "C++14" }
    buildoptions
    {
        --"-finput-charset=GBK",
        --"-fexec-charset=GBK",
        --"-fwide-exec-charset=UTF-16LE"
    }
    linkoptions
    {
        --"-static-libgcc",
        --"-static-libstdc++"
        "-static"
       
    }
    includedirs
    {
        "3rdparty/boost"
    }
    libdirs 
    {
        "3rdparty/boost/stage/lib",
        "lib/%{_ARGS[1]}/%{_ACTION}",                
        "bin/%{_ARGS[1]}/%{_ACTION}"            
    } 
		

    configurations { "Debug", "Release", "TRACE" }        

    filter { "kind:StaticLib"}       
        targetsuffix "-s"
        targetdir "lib/%{_ARGS[1]}/%{_ACTION}"     
    filter { "kind:SharedLib", "platforms:Win32" }
        implibdir "lib/%{_ARGS[1]}/%{_ACTION}"             
    filter { "kind:ConsoleApp or WindowedApp or SharedLib"}
        targetdir "bin/%{_ARGS[1]}/%{_ACTION}/%{wks.name}"         
    
    filter "configurations:not *Debug*"
        defines { "NDEBUG" }        
        optimize "Speed"      

    
       
    
    filter "configurations:TRACE"               
        includedirs
        {            
            "3rdparty"    
        }  
        links { "tracetool.lib" }  



    function create_console_project(name, dir)        
        project(name)          
        kind "ConsoleApp"                                             
        files
        {                                  
            dir .. "/%{prj.name}/**.h",
            dir .. "/%{prj.name}/**.cpp", 
            dir .. "/%{prj.name}/**.c", 
            dir .. "/%{prj.name}/**.rc" 
        }
        removefiles
        {               
        }
        includedirs
        {               
            "3rdparty",          
        }                              
    end    

    project "DevCppDLL"        
        language "C++"        
        kind "SharedLib"
        defines { "BUILDING_DLL" }
        files 
        { 
            "src/mingw-examples/DevCppDLL/**.h", 
            "src/mingw-examples/DevCppDLL/**.cpp" 
        }
        
    project "test-DevCppDLL"
        kind "ConsoleApp"
        language "C++"
        files 
        { 
            "src/mingw-examples/test-DevCppDLL/**.h", 
            "src/mingw-examples/test-DevCppDLL/**.cpp" 
        }
        links
        {
            "DevCppDLL"
        }   
        


    project "liblua"            
            kind "StaticLib"    
            defines { "_WIN32" }
            files
            {
                "3rdparty/lua-5.3.3/**.h",
                "3rdparty/lua-5.3.3/**.c"                               
            } 
            removefiles
            {
                "3rdparty/lua-5.3.3/luac.c",
                "3rdparty/lua-5.3.3/lua.c"
            }  
            targetname "lua-static"

          
            
        project "lua"            
            kind "ConsoleApp"    
            defines { "_WIN32" }
            files
            {
                "3rdparty/lua-5.3.3/**.h",
                "3rdparty/lua-5.3.3/**.c"                               
            } 
            removefiles
            {
                "3rdparty/lua-5.3.3/luac.c"                
            }  

        project "luac"            
            kind "ConsoleApp"           
            defines { "_WIN32" }
            files
            {
                "3rdparty/lua-5.3.3/**.h",
                "3rdparty/lua-5.3.3/**.c"                               
            } 
            removefiles
            {
                "3rdparty/lua-5.3.3/lua.c"                
            }  

        project "test-lua-bind"            
            kind "ConsoleApp"           
            defines { "_WIN32", "LUA_BIND_USE_BOOST" }
            files
            {
                "src/mingw-examples/test-lua-bind/**.h",
                "src/mingw-examples/test-lua-bind/**.cpp"                               
            } 
            includedirs
            {
                "3rdparty/lua-5.3.3"
            }
            links
            {
                "lua-static-s"
            }


    matches = os.matchdirs("src/mingw-examples/*")
        for i = #matches, 1, -1 do
            if string.sub(path.getname(matches[i]), 1, 4) == "test" then
                create_console_project(path.getname(matches[i]), "src/mingw-examples")
            end
            --p.w(path.getname(matches[i]))  
            
        end