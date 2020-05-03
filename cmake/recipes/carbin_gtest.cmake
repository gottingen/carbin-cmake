


find_package(GTest REQUIRED)

carbin_check_target(GTest::Main)
carbin_check_target(GTest::GTest)

set(CARBIN_GTEST_FOUND 1)
set(CARBIN_GTEST_LIBRARY       ${GTEST_LIBRARY})
set(CARBIN_GTEST_MAIN_LIBRARY  ${GTEST_MAIN_LIBRARY})
