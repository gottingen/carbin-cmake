

include(CMakeParseArguments)
include(carbin_config_cxx_opts)
include(carbin_install_dirs)
include(carbin_print_list)
include(carbin_print)
include(carbin_variable)

# carbin_cc_library(  NAME myLibrary
#                  NAMESPACE myNamespace
#                  SOURCES
#                       myLib.cpp
#                       myLib_functions.cpp
#                  HEADERS
#                        mylib.h
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
#                  PUBLIC
#                  SHARED

################################################################################
# Create a Library.
#
# Example usage:
#
# carbin_cc_library(  NAME myLibrary
#                  NAMESPACE myNamespace
#                  SOURCES
#                       myLib.cpp
#                       myLib_functions.cpp
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
#                  EXPORT_FILE_PATH
#                      ${CMAKE_BINARY_DIR}/MYLIBRARY_EXPORT.h
# )
#
# The above example creates an alias target, myNamespace::myLibrary which can be
# linked to by other tar gets.
# PUBLIC_DEFINITIONS -  preprocessor defines which are inherated by targets which
#                       link to this library
#
# PRIVATE_DEFINITIONS - preprocessor defines which are private and only seen by
#                       myLibrary
#
# PUBLIC_INCLUDE_PATHS - include paths which are public, therefore inherted by
#                        targest which link to this library.
#
# PRIVATE_INCLUDE_PATHS - private include paths which are only visible by MyLibrary
#
# LINKED_TARGETS        - targets to link to.
#
# EXPORT_FILE_PATH      - the export file to generate for dll files.
################################################################################
function(carbin_cc_library)
    set(options
            PUBLIC
            SHARED
            )
    set(args NAME
            NAMESPACE
            )

    set(list_args
            PUBLIC_LINKED_TARGETS
            PRIVATE_LINKED_TARGETS
            SOURCES
            HEADERS
            PUBLIC_DEFINITIONS
            PRIVATE_DEFINITIONS
            PUBLIC_INCLUDE_PATHS
            PRIVATE_INCLUDE_PATHS
            PUBLIC_COMPILE_FEATURES
            PRIVATE_COMPILE_FEATURES
            PUBLIC_COMPILE_OPTIONS
            PRIVATE_COMPILE_OPTIONS
            )

    cmake_parse_arguments(
            PARSE_ARGV 0
            CARBIN_CC_LIB
            "${options}"
            "${args}"
            "${list_args}"
    )


    if("${CARBIN_CC_LIB_NAME}" STREQUAL "")
        get_filename_component(CARBIN_CC_LIB_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
        string(REPLACE " " "_" CARBIN_CC_LIB_NAME ${CARBIN_CC_LIB_NAME})
        carbin_print(" Library, NAME argument not provided. Using folder name:  ${CARBIN_CC_LIB_NAME}")
    endif()

    if("${CARBIN_CC_LIB_NAMESPACE}" STREQUAL "")
        set(CARBIN_CC_LIB_NAMESPACE ${CARBIN_CC_LIB_NAME})
        message(" Library, NAMESPACE argument not provided. Using target alias:  ${CARBIN_CC_LIB_NAME}::${CARBIN_CC_LIB_NAME}")
    endif()


    message("-----------------------------------")
    carbin_print_label("Create Library" "${CARBIN_CC_LIB_NAMESPACE}::${CARBIN_CC_LIB_NAME}")
    message("-----------------------------------")
    carbin_print_list_label("Sources" CARBIN_CC_LIB_SOURCES)
    carbin_print_list_label("Public Linked Targest"  CARBIN_CC_LIB_PUBLIC_LINKED_TARGETS)
    carbin_print_list_label("Private Linked Targest"  CARBIN_CC_LIB_PRIVATE_LINKED_TARGETS)
    carbin_print_list_label("Public Include Paths"  CARBIN_CC_LIB_PUBLIC_INCLUDE_PATHS)
    carbin_print_list_label("Private Include Paths" CARBIN_CC_LIB_PRIVATE_INCLUDE_PATHS)
    carbin_print_list_label("Public Compile Features" CARBIN_CC_LIB_PUBLIC_COMPILE_FEATURES)
    carbin_print_list_label("Private Compile Features" CARBIN_CC_LIB_PRIVATE_COMPILE_FEATURES)
    carbin_print_list_label("Public Definitions" CARBIN_CC_LIB_PUBLIC_DEFINITIONS)
    carbin_print_list_label("Private Definitions" CARBIN_CC_LIB_PRIVATE_DEFINITIONS)
    if (CARBIN_CC_LIB_PUBLIC)
        carbin_print_label("Public" "true")
    else ()
        carbin_print_label("Public" "false")
    endif ()
    if (CARBIN_CC_LIB_SHARED)
        set(CARBIN_BUILD_TYPE "SHARED")
        carbin_print_label("Shared" "true")
    else ()
        set(CARBIN_BUILD_TYPE "STATIC")
        carbin_print_label("Shared" "false")
    endif ()

    if ("${CARBIN_CC_LIB_SOURCES}" STREQUAL "")
        carbin_print_label("Interface" "true")
        set(CARBIN_CC_LIB_IS_INTERFACE 1)
    else ()
        carbin_print_label("Interface" "false")
        set(CARBIN_CC_LIB_IS_INTERFACE 0)
    endif ()

    message("-----------------------------------")

    if (NOT CARBIN_CC_LIB_IS_INTERFACE)
        add_library( ${CARBIN_CC_LIB_NAME} ${CARBIN_BUILD_TYPE} ${CARBIN_CC_LIB_SOURCES} ${CARBIN_CC_LIB_HEADERS})
        add_library( ${CARBIN_CC_LIB_NAMESPACE}::${CARBIN_CC_LIB_NAME}  ALIAS  ${CARBIN_CC_LIB_NAME}   )

        target_compile_features(${CARBIN_CC_LIB_NAME} PUBLIC ${CARBIN_CC_LIB_PUBLIC_COMPILE_FEATURES} )
        target_compile_features(${CARBIN_CC_LIB_NAME} PRIVATE ${CARBIN_CC_LIB_PRIVATE_COMPILE_FEATURES} )

        target_compile_options(${CARBIN_CC_LIB_NAME} PUBLIC ${CARBIN_CC_LIB_PUBLIC_COMPILE_OPTIONS} )
        target_compile_options(${CARBIN_CC_LIB_NAME} PRIVATE ${CARBIN_CC_LIB_PRIVATE_COMPILE_OPTIONS} )

        target_link_libraries( ${CARBIN_CC_LIB_NAME} PUBLIC ${CARBIN_CC_LIB_PUBLIC_LINKED_TARGETS})
        target_link_libraries( ${CARBIN_CC_LIB_NAME} PRIVATE ${CARBIN_CC_LIB_PRIVATE_LINKED_TARGETS})

        target_include_directories( ${CARBIN_CC_LIB_NAME}
                PUBLIC
                ${CARBIN_CC_LIB_INCLUDE_PATHS}
                ${CARBIN_CC_LIB_PUBLIC_INCLUDE_PATHS}
                PRIVATE
                ${CARBIN_CC_LIB_PRIVATE_INCLUDE_PATHS}
                )

        target_compile_definitions( ${CARBIN_CC_LIB_NAME}
                PUBLIC
                ${CARBIN_CC_LIB_PUBLIC_DEFINITIONS}
                PRIVATE
                ${CARBIN_CC_LIB_PRIVATE_DEFINITIONS}
                )
    else()
        add_library( ${CARBIN_CC_LIB_NAME} INTERFACE)
        add_library( ${CARBIN_CC_LIB_NAMESPACE}::${CARBIN_CC_LIB_NAME}  ALIAS  ${CARBIN_CC_LIB_NAME})
        target_compile_features(${CARBIN_CC_LIB_NAME} INTERFACE ${CARBIN_CC_LIB_PUBLIC_COMPILE_FEATURES} )
        target_compile_features(${CARBIN_CC_LIB_NAME} INTERFACE ${CARBIN_CC_LIB_PRIVATE_COMPILE_FEATURES} )

        target_compile_options(${CARBIN_CC_LIB_NAME} INTERFACE ${CARBIN_CC_LIB_PUBLIC_COMPILE_OPTIONS} )
        target_compile_options(${CARBIN_CC_LIB_NAME} INTERFACE ${CARBIN_CC_LIB_PRIVATE_COMPILE_OPTIONS} )

        target_link_libraries( ${CARBIN_CC_LIB_NAME} INTERFACE
                ${CARBIN_CC_LIB_PUBLIC_LINKED_TARGETS}
                ${CARBIN_CC_LIB_PRIVATE_LINKED_TARGETS}
                )

        target_include_directories( ${CARBIN_CC_LIB_NAME}
                INTERFACE
                ${CARBIN_CC_LIB_INCLUDE_PATHS}
                ${CARBIN_CC_LIB_PUBLIC_INCLUDE_PATHS}
                ${CARBIN_CC_LIB_PRIVATE_INCLUDE_PATHS}
                )

        target_compile_definitions(${CARBIN_CC_LIB_NAME} INTERFACE ${CARBIN_CC_LIB_DEFINES})

    endif()

    if (CARBIN_CC_LIB_PUBLIC)

        install(TARGETS ${CARBIN_CC_LIB_NAME}
                EXPORT ${PROJECT_NAME}Targets
                RUNTIME DESTINATION ${CARBIN_INSTALL_BINDIR}
                LIBRARY DESTINATION ${CARBIN_INSTALL_LIBDIR}
                ARCHIVE DESTINATION ${CARBIN_INSTALL_LIBDIR}
                INCLUDES DESTINATION ${CARBIN_INSTALL_INCLUDEDIR}
                )
    endif ()

    foreach(arg IN LISTS CARBIN_CC_LIB_UNPARSED_ARGUMENTS)
        message(WARNING "Unparsed argument: ${arg}")
    endforeach()

endfunction()

