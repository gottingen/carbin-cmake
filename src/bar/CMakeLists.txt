

find_package(Threads REQUIRED)
carbin_cc_library(
        NAME bar
        NAMESPACE carbin
        HEADERS
        bar.h
        PRIVATE_DEFINITIONS
            DEBUG=true
        PRIVATE_LINKED_TARGETS
            Threads::Threads
        PUBLIC
)

install(
        DIRECTORY   "${CMAKE_SOURCE_DIR}/src/bar"
        DESTINATION "${CARBIN_INSTALL_INCLUDEDIR}/barls"
        FILES_MATCHING PATTERN "*.h"
)

# Example usage:
#
# carbin_cc_binary(  NAME myExe
#                  SOURCES
#                       main.cpp
#                  PUBLIC_DEFINITIONS
#                     USE_DOUBLE_PRECISION=1
#                  PRIVATE_DEFINITIONS
#                     DEBUG_VERBOSE
#                  PUBLIC_INCLUDE_PATHS
#                     ${CMAKE_SOURCE_DIR}/mylib/include
#                  PRIVATE_INCLUDE_PATHS
#                     ${CMAKE_SOURCE_DIR}/include
#                  PRIVATE_LINKED_TARGETS
#                     Threads::Threads
#                  PUBLIC_LINKED_TARGETS
#                     Threads::Threads
#                  LINKED_TARGETS
#                     Threads::Threads
#                     myNamespace::myLib
# )

carbin_cc_binary(
        NAME bar_main
        SOURCES bar_main.cc
)