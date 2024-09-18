cmake_minimum_required(VERSION 3.22)
project(apparo)

set(CMAKE_CXX_STANDARD 20)

add_subdirectory(3p)

add_executable(apparo
        src/entry.cpp
)

target_link_libraries(apparo dpp)
