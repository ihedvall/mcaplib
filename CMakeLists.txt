# Copyright 2024 Ingemar Hedvall
# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.20)
include(CMakePrintHelpers)

if("${CMAKE_TOOLCHAIN_FILE}" STREQUAL "")
    set(USE_VCPKG OFF)
else()
    set(USE_VCPKG ON)
endif()

option(BUILD_SHARED_LIBS "Static libraries are preferred" OFF)
option(BUILD_STATIC_LIBS "Static libraries are preferred" ON)
option(MCAP_DOC "If doxygen is installed, then build documentation in Release mode" OFF)
option(MCAP_TOOLS "Building applications" OFF)
option(MCAP_TEST "Building unit test" OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(MCAP_TOOLS AND USE_VCPKG)
    list(APPEND VCPKG_MANIFEST_FEATURES "tools")
endif()

if(MCAP_TEST AND USE_VCPKG)
    list(APPEND VCPKG_MANIFEST_FEATURES "tests")
endif()

# Build the LZ4 library
include(script/lz4.cmake)

# Include the ZSTD library
include(script/zstd.cmake)

project(mcaplib
        VERSION 1.0
        DESCRIPTION "MCAP build wrapper library."
        LANGUAGES CXX)


set(CMAKE_CXX_STANDARD 20)
set(CMAKE_DEBUG_POSTFIX d)


if (MCAP_TOOLS)
    include(script/wxwidgets.cmake)
endif()

if (MCAP_TEST)
    include(script/googletest.cmake)
endif()

if (MCAP_DOC)
    include(script/doxygen.cmake)
endif()





#set(MCAP_HEADERS TODO )

#add_library(mcap     ${MCAP_HEADERS} )
add_executable( test_mcap src/main.cpp )

#target_include_directories(mcap PUBLIC
#        $<INSTALL_INTERFACE:include>
#        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
#       )
target_include_directories(test_mcap PRIVATE ${zstd_SOURCE_DIR}/lib)
target_include_directories(test_mcap PRIVATE ${lz4_SOURCE_DIR}/lib)
target_include_directories(test_mcap PRIVATE "extern/mcap/cpp/mcap/include")

cmake_print_properties(TARGETS test_mcap PROPERTIES INCLUDE_DIRECTORIES)

if (MSVC)
    target_compile_definitions(test_mcap PRIVATE _WIN32_WINNT=0x0A00)
endif ()

target_link_libraries(test_mcap PRIVATE lz4_static)
target_link_libraries(test_mcap PRIVATE libzstd_static)


if (wxWidgets_FOUND AND DBC_TOOLS)
    add_subdirectory(mcapviewer)
endif ()

if (MCAP_TEST)
    enable_testing()
    add_subdirectory(test)
endif ()

if (DOXYGEN_FOUND AND (CMAKE_BUILD_TYPE MATCHES "^[Rr]elease") AND MCAP_DOC)
    set(DOXYGEN_RECURSIVE NO)
    set(DOXYGEN_REPEAT_BRIEF NO)
    set(DOXYGEN_PROJECT_NAME "McapLib")
    set(DOXYGEN_HTML_EXTRA_STYLESHEET doxygen/mcaplib.css)
    set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/docs/manual)
    doxygen_add_docs(doc_libmcap ALL
            include/mcap doxygen
            COMMENT "MCAP Library generating API documentation with Doxygen")
endif ()

