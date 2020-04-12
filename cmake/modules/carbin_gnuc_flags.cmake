
set(CARBIN_GNUC_CXX_FLAGS
        -DCHECK_PTHREAD_RETURN_VALUE
        -D_FILE_OFFSET_BITS=64
        -Wall
        -Wextra
        -Werror
        -Wno-unused-parameter
        -Wno-unused-function
        -Wno-missing-field-initializers
        -Wno-sign-compare
        -Woverloaded-virtual
        -Wno-deprecated-declarations
        -Wpointer-arith
        -Wwrite-strings
        -Wno-maybe-uninitialized
        -march=native
        -MMD
        -fPIC
        -std=c++11
        )