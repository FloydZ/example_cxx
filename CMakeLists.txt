CMAKE_MINIMUM_REQUIRED(VERSION 3.8)
project ("example C++ project" LANGUAGES C CXX ASM)

option(USE_TCMALLOC "Enable tcmalloc" OFF)
option(USE_SIMD "Enable avx/neon" ON)

# check for compiler optimization flags
include(CheckCXXCompilerFlag)
# check for -flto
include(CheckIPOSupported)

check_cxx_compiler_flag(-Wno-c11-extensions COMPILER_SUPPORTS_C11_EXCEPTION)


enable_testing()

set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE RelWithDebInfo)


# local cmake includes
include("deps/cmake_optimize_for_architecture/Optimizations.cmake")
# global cmake includes
include(FetchContent)
include(ExternalProject)

if(NOT DEFINED CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED True)
endif()


# local include paths
include_directories("deps")
include_directories("deps/b63/include")
include_directories("src")

# some helper variables
set(SANITIZER_FLAGS -fsanitize=address -fsanitize=bounds -fno-omit-frame-pointer -Warray-bounds -fstrict-flex-arrays)
set(GCC_HELPER_FLAGS -fvar-tracking-assignments)

set(DEBUG_FLAGS "-g -O0 -DDEBUG -Wall -Wextra -pendantic ${SANITIZER_FLAGS}")
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # if using GCC
    set(DEBUG_FLAGS "${DEBUG_FLAGS} ${GCC_HELPER_FLAGS}")
endif()

IF(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm" OR ${CMAKE_SYSTEM_PROCESSOR} MATCHES "aarch64") 
	message(STATUS "ARM CPU detected")
    set(OPTIMIZE_FLAGS "-g -O3 -DNDEBUG -flax-vector-conversions -DUSE_ARM ")
else()
	message(STATUS "X86-64 CPU detected")
    set(OPTIMIZE_FLAGS "-g -O3 -DNDEBUG -flto -march=native -DUSE_AVX2")
endif()

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${DEBUG_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${OPTIMIZE_FLAGS}")


set(LINK_TEST_FLAGS 
	GTest::gtest 
	GTest::gtest_main 
)

set(LINK_BENCH_FLAGS 
	benchmark::benchmark
)

# load external content
FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/6910c9d9165801d8827d628cb72eb7ea9dd538c5.zip
    DOWNLOAD_EXTRACT_TIMESTAMP
)
FetchContent_Declare(
    benchmark
    URL https://github.com/google/benchmark/archive/afa23b7699c17f1e26c88cbf95257b20d78d6247.zip
    DOWNLOAD_EXTRACT_TIMESTAMP
)
FetchContent_MakeAvailable(googletest)
FetchContent_MakeAvailable(benchmark)

find_package(Git QUIET)

# library
add_library(example_lib STATIC src/lib.cpp)

# executable
add_executable(example_executable main.cpp)
target_link_libraries(example_executable example_lib)

add_subdirectory(bench)
add_subdirectory(test)
