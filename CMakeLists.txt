cmake_minimum_required(VERSION 3.20)
project(LuaEngine)

#C++ 17 required (filesystem)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)

# Fetch
FetchContent_Declare(
    lua
    URL https://github.com/marovira/lua/archive/refs/tags/5.4.4.tar.gz
)
FetchContent_MakeAvailable(lua)

FetchContent_Declare(
    sol2
    URL https://github.com/ThePhD/sol2/archive/refs/tags/v3.3.0.tar.gz
)
FetchContent_MakeAvailable(sol2)

# Gather Sources
list(APPEND SOURCES 
        "src/AbstractGame.h"
        "src/AbstractGame.cpp"
        "src/Game.h"
        "src/Game.cpp"
        "src/GameDefines.h"
        "src/GameEngine.h"
        "src/GameEngine.cpp"
        "src/GameWinMain.h"
        "src/GameWinMain.cpp"
        "src/resource.h"
            
        "src/MyClasses/LuaBinder.h"  
        "src/MyClasses/LuaBinder.cpp"
) 

list(APPEND LUA_SOURCES 
       "lua/game.lua"
       "lua/Save.lua"
       "lua/Sound.lua" 

       "lua/Background.lua" 
       "lua/StaticBackground.lua"
       "lua/FloorBackground.lua"

       "lua/AnimationController.lua" 
       "lua/Animation.lua" 
        
       "lua/Entity.lua"  
       "lua/Obstacle.lua" 
       "lua/Dino.lua"  
       "lua/Cactus.lua"
       "lua/Bird.lua"

) 
             
# Executable target
set(PROJECT_NAME LuaEngine)
add_executable(${PROJECT_NAME} WIN32 ${SOURCES} ${LUA_SOURCES}) 
target_link_libraries(${PROJECT_NAME} PRIVATE lua::lua sol2) 
target_include_directories(${PROJECT_NAME} PRIVATE src)

# Copy Scripts 
add_custom_target(CopyScripts ALL COMMENT "Copying Lua scripts to output directory" )

#Copy Resources Folder
add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory 
        ${CMAKE_CURRENT_SOURCE_DIR}/Resources
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/Resources
    COMMENT "Copying Resources folder to output directory"
)

FOREACH(LUA_SOURCE IN LISTS LUA_SOURCES) 
    add_custom_command(TARGET CopyScripts POST_BUILD 
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/${LUA_SOURCE}
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/${LUA_SOURCE})
ENDFOREACH() 

add_dependencies(CopyScripts ${PROJECT_NAME})

if (MSVC)
    target_compile_definitions(${PROJECT_NAME} PUBLIC UNICODE _UNICODE)
endif()
