# Copyright 2024 Ingemar Hedvall
# SPDX-License-Identifier: MIT
include(CMakePrintHelpers)

include (FetchContent)
set(ZSTD_BUILD_STATIC ON)
set(ZSTD_BUILD_SHARED OFF)
FetchContent_Declare(zstd
        GIT_REPOSITORY https://github.com/facebook/zstd.git
        GIT_TAG HEAD
        SOURCE_SUBDIR build/cmake
)

FetchContent_MakeAvailable(zstd)

cmake_print_variables(zstd_POPULATED zstd_SOURCE_DIR zstd_BINARY_DIR)
cmake_print_properties(TARGETS libzstd_static PROPERTIES NAME)
