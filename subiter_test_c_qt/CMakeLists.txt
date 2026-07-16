cmake_minimum_required(VERSION 3.16)

project(SubiterInspections VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup()

qt_add_executable(SubiterInspections
    main.cpp

    question1.h
    question1.cpp

    question3.h
    question3.cpp
)

target_link_libraries(SubiterInspections
    PRIVATE Qt6::Core
)