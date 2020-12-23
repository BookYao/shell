cmake_minimum_required(VERSION 3.19)

message(STATUS "******************************************************************")
message(STATUS "CMAKE_SOURCE_DIR->" ${CMAKE_SOURCE_DIR})
message(STATUS "PROJECT_SOURCE_DIR->" ${PROJECT_SOURCE_DIR})
message(STATUS "CMAKE_CURRENT_DIR->" ${CMAKE_CURRENT_SOURCE_DIR})
message(STATUS "PROJECT_BINARY_DIR->" ${PROJECT_BINARY_DIR})
message(STATUS "******************************************************************")

#cmake_policy(SET CMP0015 NEW)

project(presence)

set(CMAKE_CXX_STANDARD 17)

project(presence C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ../bin)

# define dynamic library load path when program running
SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
SET(CMAKE_INSTALL_RPATH "/usr/local/presence/glib")
SET(CMAKE_INSTALL_RPATH "/usr/local/presence/zlog")

# defien head file path
include_directories(include)

# define source file path
aux_source_directory(./src DIR_SRCS)

# compile param
add_definitions("-g -Wall")

# add zlog head file
include_directories(lib/zlog/include)

FIND_LIBRARY(GLIB glib-2.0 lib/lib/glib/lib64)

# add glib head file
include_directories(lib/glib/include/glib-2.0)
include_directories(lib/glib/lib64/glib-2.0/include)

# define link dynamic library path
link_directories(lib/glib/lib64)
link_directories(lib/zlog/lib)

#SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

add_executable(presence ${DIR_SRCS})

# define dynamic link library
target_link_libraries(presence "zlog")
target_link_libraries(presence "pthread")
target_link_libraries(presence "glib-2.0")

