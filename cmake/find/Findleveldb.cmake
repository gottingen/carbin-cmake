# Findleveldb
# --------
#
# Find leveldb headers and libraries.
#
# Use this module by invoking find_package with the form::
#
#   find_package(leveldb)
#
# Results are reported in variables::
#
#   CARBIN_LEVELDB_INCLUDE_DIRS     - Where to find leveldb.h
#   CARBIN_LEVELDB_SHARED_LIBRARIES - Location of leveldb shared library
#   CARBIN_LEVELDB_STATIC_LIBRARIES - Location of leveldb static library
#  CARBIN_ LEVELDB_FOUND            - True if leveldb is found
#
# This module reads hints about search locations from variables::
#
#   LEVELDB_ROOT    - Installation prefix
#
# and saves search results persistently in CMake cache entries::
#
#   CARBIN_LEVELDB_INCLUDE_DIR      - Preferred include directory
#   CARBIN_LEVELDB_SHARED_LIBRARY   - Preferred shared library
#   CARBIN_LEVELDB_STATIC_LIBRARY   - Preferred static library
#
# The following targets are also defined::
#
#   CARBIN_LevelDB        - Interface target for this shared library
#   CARBIN_LevelDB_static - Interface target for this static library

#=============================================================================

set(HEADER_FILENAME "leveldb.h")
set(LIBRARY_PREFIX "libleveldb")

set(sharedlibs)
set(staticlibs)

list(APPEND sharedlibs "${LIBRARY_PREFIX}.so")
list(APPEND staticlibs "${LIBRARY_PREFIX}.a")

if(LEVELDB_ROOT)
    file(TO_CMAKE_PATH ${LEVELDB_ROOT} LEVELDB_ROOT)

    find_path(LEVELDB_INCLUDE_DIR NAMES leveldb/${HEADER_FILENAME}
            PATHS ${LEVELDB_ROOT}/include
            NO_DEFAULT_PATH)

    if(LEVELDB_CMAKE_DEBUG)
        message(STATUS "found include dir: ${LEVELDB_INCLUDE_DIR}")
    endif()

    find_library(LEVELDB_SHARED_LIBRARY NAMES ${sharedlibs}
            PATHS ${LEVELDB_ROOT}/lib
            NO_DEFAULT_PATH)

    find_library(LEVELDB_STATIC_LIBRARY NAMES ${staticlibs}
            PATHS ${LEVELDB_ROOT}/lib
            NO_DEFAULT_PATH)

    if(LEVELDB_CMAKE_DEBUG)
        message(STATUS "found shared libs: ${LEVELDB_SHARED_LIBRARY}")
        message(STATUS "found static libs: ${LEVELDB_STATIC_LIBRARY}")
    endif()
endif()

find_path(LEVELDB_INCLUDE_DIR NAMES ${HEADER_FILENAME})

find_library(LEVELDB_SHARED_LIBRARY NAMES ${sharedlibs}
        PATHS ${LEVELDB_ROOT}/lib NO_DEFAULT_PATH)

find_library(LEVELDB_STATIC_LIBRARY NAMES ${staticlibs}
        PATHS ${LEVELDB_ROOT}/lib NO_DEFAULT_PATH)

# handle the QUIETLY and REQUIRED arguments and set LEVELDB_FOUND to TRUE
# if all listed variables are TRUE
include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(LevelDB
        FOUND_VAR LEVELDB_FOUND
        REQUIRED_VARS
        LEVELDB_SHARED_LIBRARY LEVELDB_STATIC_LIBRARY LEVELDB_INCLUDE_DIR)

if(LEVELDB_FOUND)
    mark_as_advanced(LEVELDB_INCLUDE_DIR)
    mark_as_advanced(LEVELDB_SHARED_LIBRARY)
    mark_as_advanced(LEVELDB_STATIC_LIBRARY)

    set(CARBIN_LEVELDB_INCLUDE_DIRS ${LEVELDB_INCLUDE_DIR})
    set(CARBIN_LEVELDB_STATIC_LIBRARIES ${LEVELDB_STATIC_LIBRARY})
    set(CARBIN_LEVELDB_SHARED_LIBRARIES ${LEVELDB_SHARED_LIBRARY})

    set(TRGT_NAME1 "LevelDB")

    if(NOT TARGET ${TRGT_NAME1})
        add_library(${TRGT_NAME1} INTERFACE)
        target_include_directories(${TRGT_NAME1} INTERFACE ${CARBIN_LEVELDB_INCLUDE_DIRS})
        target_link_libraries(${TRGT_NAME1} INTERFACE ${CARBIN_LEVELDB_SHARED_LIBRARIES})
    endif()

    set(TRGT_NAME2 "LevelDB_static")

    if(NOT TARGET ${TRGT_NAME2})
        add_library(${TRGT_NAME2} INTERFACE)
        target_include_directories(${TRGT_NAME2} INTERFACE ${CARBIN_LEVELDB_INCLUDE_DIRS})
        target_link_libraries(${TRGT_NAME2} INTERFACE ${CARBIN_LEVELDB_STATIC_LIBRARIES})
    endif()
endif()
