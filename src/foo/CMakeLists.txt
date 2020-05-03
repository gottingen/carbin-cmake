

find_package(Threads REQUIRED)
carbin_cc_library(
        NAME foo
        NAMESPACE carbin
        SOURCES
        foo.cc
        HEADERS
        foo.h
        PRIVATE_DEFINITIONS
            DEBUG=true
        PRIVATE_LINKED_TARGETS
            Threads::Threads
)
