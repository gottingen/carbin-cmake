# Findjemalloc
# --------
#
# Find jemalloc headers and libraries.
#
# Use this module by invoking find_package with the form::
#
#   find_package(jemalloc)
#
# Results are reported in variables::
#
#   JEMALLOC_INCLUDE_DIRS     - Where to find jemalloc.h
#   JEMALLOC_SHARED_LIBRARIES - Location of jemalloc shared library
#   JEMALLOC_STATIC_LIBRARIES - Location of jemalloc static library
#   JEMALLOC_FOUND            - True if jemalloc is found
#
# This module reads hints about search locations from variables::
#
#   JEMALLOC_ROOT    - Installation prefix
#
# and saves search results persistently in CMake cache entries::
#
#   JEMALLOC_INCLUDE_DIR      - Preferred include directory
#   JEMALLOC_SHARED_LIBRARY   - Preferred shared library
#   JEMALLOC_STATIC_LIBRARY   - Preferred static library
#
# The following targets are also defined::
#
#   Jemalloc        - Interface target for this shared library
#   Jemalloc_static - Interface target for this static library

#=============================================================================

set(HEADER_FILENAME "jemalloc.h")
set(LIBRARY_PREFIX "libjemalloc")

set(sharedlibs)
set(staticlibs)

list(APPEND sharedlibs "${LIBRARY_PREFIX}.so")
list(APPEND staticlibs "${LIBRARY_PREFIX}_pic.a")
list(APPEND staticlibs "${LIBRARY_PREFIX}.a")

if(JEMALLOC_ROOT)
    file(TO_CMAKE_PATH ${JEMALLOC_ROOT} JEMALLOC_ROOT)

    find_path(JEMALLOC_INCLUDE_DIR NAMES jemalloc/${HEADER_FILENAME}
            PATHS ${JEMALLOC_ROOT}/include
            NO_DEFAULT_PATH)

    if(JEMALLOC_CMAKE_DEBUG)
        message(STATUS "found include dir: ${JEMALLOC_INCLUDE_DIR}")
    endif()

    find_library(JEMALLOC_SHARED_LIBRARY NAMES ${sharedlibs}
            PATHS ${JEMALLOC_ROOT}/lib
            NO_DEFAULT_PATH)

    find_library(JEMALLOC_STATIC_LIBRARY NAMES ${staticlibs}
            PATHS ${JEMALLOC_ROOT}/lib
            NO_DEFAULT_PATH)

    if(JEMALLOC_CMAKE_DEBUG)
        message(STATUS "found shared libs: ${JEMALLOC_SHARED_LIBRARY}")
        message(STATUS "found static libs: ${JEMALLOC_STATIC_LIBRARY}")
    endif()
endif()

find_path(JEMALLOC_INCLUDE_DIR NAMES ${HEADER_FILENAME})

find_library(JEMALLOC_SHARED_LIBRARY NAMES ${sharedlibs}
        PATHS ${JEMALLOC_ROOT}/lib NO_DEFAULT_PATH)

find_library(JEMALLOC_STATIC_LIBRARY NAMES ${staticlibs}
        PATHS ${JEMALLOC_ROOT}/lib NO_DEFAULT_PATH)

# handle the QUIETLY and REQUIRED arguments and set JEMALLOC_FOUND to TRUE
# if all listed variables are TRUE
include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Jemalloc
        FOUND_VAR JEMALLOC_FOUND
        REQUIRED_VARS
        JEMALLOC_SHARED_LIBRARY JEMALLOC_STATIC_LIBRARY JEMALLOC_INCLUDE_DIR)

if(JEMALLOC_FOUND)
    mark_as_advanced(JEMALLOC_INCLUDE_DIR)
    mark_as_advanced(JEMALLOC_SHARED_LIBRARY)
    mark_as_advanced(JEMALLOC_STATIC_LIBRARY)

    set(CARBIN_JEMALLOC_INCLUDE_DIRS ${JEMALLOC_INCLUDE_DIR})
    set(CARBIN_JEMALLOC_STATIC_LIBRARIES ${JEMALLOC_STATIC_LIBRARY})
    set(CARBIN_JEMALLOC_SHARED_LIBRARIES ${JEMALLOC_SHARED_LIBRARY})

    set(TRGT_NAME1 "Jemalloc")

    if(NOT TARGET ${TRGT_NAME1})
        add_library(${TRGT_NAME1} INTERFACE)
        target_include_directories(${TRGT_NAME1} INTERFACE ${CARBIN_JEMALLOC_INCLUDE_DIRS})
        target_link_libraries(${TRGT_NAME1} INTERFACE ${CARBIN_JEMALLOC_SHARED_LIBRARIES})
    endif()

    set(TRGT_NAME2 "Jemalloc_static")

    if(NOT TARGET ${TRGT_NAME2})
        add_library(${TRGT_NAME2} INTERFACE)
        target_include_directories(${TRGT_NAME2} INTERFACE ${CARBIN_JEMALLOC_INCLUDE_DIRS})
        target_link_libraries(${TRGT_NAME2} INTERFACE ${CARBIN_JEMALLOC_STATIC_LIBRARIES})
    endif()
endif()