cmake_minimum_required(VERSION 3.14)
project(stoidoc C)

set(CMAKE_C_STANDARD 11)

include_directories(.)

add_executable(stoidoc
        idoc.c
        label.c
        label.h strl.h strl.c lookup.c lookup.h)