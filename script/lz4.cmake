# Copyright 2024 Ingemar Hedvall
# SPDX-License-Identifier: MIT
include(CMakePrintHelpers)
include (FetchContent)

set(BUILD_STATIC_LIBS ON)
set(BUILD_SHARED_LIBS OFF)
set(LZ4_BUILD_CLI OFF)
set(LZ4_BUILD_LEGACY_LZ4C OFF)

FetchContent_Declare(lz4
        GIT_REPOSITORY https://github.com/lz4/lz4.git
        GIT_TAG HEAD
        SOURCE_SUBDIR build/cmake
)

FetchContent_MakeAvailable(lz4)

cmake_print_variables(lz4_POPULATED lz4_SOURCE_DIR lz4_BINARY_DIR)
cmake_print_properties(TARGETS lz4_static PROPERTIES NAME)