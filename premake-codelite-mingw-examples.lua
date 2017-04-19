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

    
    libdirs 
    {
        "lib/%{_ARGS[1]}/%{_ACTION}",
        "lib/%{_ARGS[1]}/%{_ACTION}/boost-1_56",
        "lib/%{_ARGS[1]}/%{_ACTION}/boost-1_60",
        "bin/%{_ARGS[1]}/%{_ACTION}"            
    }    
    
    filter "configurations:TRACE"               
        includedirs
        {            
            "3rdparty"    
        }  
        links { "tracetool.lib" }  

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
