

include(CMakeParseArguments)
include(carbin_config_cxx_opts)
include(carbin_install_dirs)
include(carbin_print_list)

function(carbin_cc_test)
    set(options)
    set(args NAME
            WORKING_DIRECTORY
            )

    set(list_args
            PUBLIC_LINKED_TARGETS
            PRIVATE_LINKED_TARGETS
            SOURCES
            COMMAND
            PUBLIC_DEFINITIONS
            PRIVATE_DEFINITIONS
            PUBLIC_INCLUDE_PATHS
            PRIVATE_INCLUDE_PATHS
            PUBLIC_COMPILE_FEATURES
            PRIVATE_COMPILE_FEATURES
            )

    cmake_parse_arguments(
            PARSE_ARGV 0
            CARBIN_CC_TEST
            "${options}"
            "${args}"
            "${list_args}"
    )


    message("-----------------------------------")
    message("${carbin_bold_magenta}Building Test${carbin_colour_reset}:        ${carbin_greem}${CARBIN_CC_TEST_NAME}${carbin_colour_reset}")
    message("-----------------------------------")
    message("${carbin_bold_magenta}Command to Execute${carbin_colour_reset}: ${carbin_greem}${CARBIN_CC_TEST_COMMAND}${carbin_colour_reset}")
    message("${carbin_bold_magenta}Working Directory${carbin_colour_reset} : ${carbin_greem}${CARBIN_CC_TEST_WORKING_DIRECTORY}${carbin_colour_reset}")
    carbin_print_list_label("Sources" CARBIN_CC_TEST_SOURCES)
    carbin_print_list_label("Public Linked Targest"  CARBIN_CC_TEST_PUBLIC_LINKED_TARGETS)
    carbin_print_list_label("Private Linked Targest"  CARBIN_CC_TEST_PRIVATE_LINKED_TARGETS)
    carbin_print_list_label("Public Include Paths"  CARBIN_CC_TEST_PUBLIC_INCLUDE_PATHS)
    carbin_print_list_label("Private Include Paths" CARBIN_CC_TEST_PRIVATE_INCLUDE_PATHS)
    carbin_print_list_label("Public Compile Features" CARBIN_CC_TEST_PUBLIC_COMPILE_FEATURES)
    carbin_print_list_label("Private Compile Features" CARBIN_CC_TEST_PRIVATE_COMPILE_FEATURES)
    carbin_print_list_label("Public Definitions" CARBIN_CC_TEST_PUBLIC_DEFINITIONS)
    carbin_print_list_label("Private Definitions" CARBIN_CC_TEST_PRIVATE_DEFINITIONS)
    message("-----------------------------------")


    set(testcase ${CARBIN_CC_TEST_NAME} )

    add_executable(${testcase} ${CARBIN_CC_TEST_SOURCES})
    target_compile_definitions(${testcase} PRIVATE
            #CATCH_CONFIG_FAST_COMPILE
            $<$<CXX_COMPILER_ID:MSVC>:_SCL_SECURE_NO_WARNINGS>
            ${CARBIN_CC_TEST_PRIVATE_DEFINITIONS}
            ${CARBIN_CC_TEST_PUBLIC_DEFINITIONS}
            )
    target_compile_options(${testcase} PRIVATE
            $<$<CXX_COMPILER_ID:MSVC>:/EHsc;$<$<CONFIG:Release>:/Od>>
            # $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wno-deprecated;-Wno-float-equal>
            $<$<CXX_COMPILER_ID:GNU>:-Wno-deprecated-declarations>
            ${CARBIN_CC_TEST_PUBLIC_COMPILE_FEATURES}
            ${CARBIN_CC_TEST_PRIVATE_COMPILE_FEATURES}
            )
    target_include_directories(${testcase} PRIVATE
            ${CARBIN_CC_TEST_PUBLIC_INCLUDE_PATHS}
            ${CARBIN_CC_TEST_PRIVATE_INCLUDE_PATHS}
            )

    target_link_libraries(${testcase} ${CARBIN_CC_TEST_PUBLIC_LINKED_TARGETS} ${CARBIN_CC_TEST_PRIVATE_LINKED_TARGETS} )
    #target_link_libraries(${testcase} --coverage -g -O0 -fprofile-arcs -ftest-coverage)
    #target_compile_options(${testcase} PRIVATE --coverage -g -O0 -fprofile-arcs -ftest-coverage)

    #MESSAGE("         Adding link libraries for ${testcase}: ${GNL_LIBS}  ${GNL_COVERAGE_FLAGS} ")

    add_test( NAME ${testcase}
            COMMAND ${CARBIN_CC_TEST_COMMAND}
            WORKING_DIRECTORY ${CARBIN_CC_TEST_WORKING_DIRECTORY})

endfunction()
