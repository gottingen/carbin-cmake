
set(PROJECT_DESCRIPTION "carbin c++ lib")
set(PROJECT_VERSION_MAJOR 1)
set(PROJECT_VERSION_MINOR 2)
set(PROJECT_VERSION_PATCH 0)
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

option(CARBIN_STATUS_PRINT "cmake toolchain print" ON)
option(CARBIN_STATUS_DEBUG "cmake toolchain debug info" ON)

option(ENABLE_TESTING "enable unit test" ON)
option(CARBIN_PACKAGE_GEN "enable package gen" ON)
option(ENABLE_BENCHMARK "enable benchmark" ON)
option(ENABLE_EXAMPLE "enable benchmark" ON)

if (ENABLE_TESTING)
    set(CARBIN_RUN_TESTS true)
endif ()

set(CMAKE_VERBOSE_MAKEFILE OFF)

set(CMAKE_MACOSX_RPATH 1)

set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)

set(CMAKE_INSTALL_PREFIX ${CARBIN_PREFIX})
carbin_print("project will install to ${CMAKE_INSTALL_PREFIX}")

set(PACKAGE_INSTALL_PREFIX "/usr/local")