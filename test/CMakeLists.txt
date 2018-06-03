# 3.8 for cxx_std_11
cmake_minimum_required(VERSION 3.8.0 FATAL_ERROR)
project(findbdb-test LANGUAGES CXX)

# The test exe that runs an open/close of a Berkeley DB
add_executable(findbdb-test "main.cpp")

target_compile_features(findbdb-test PRIVATE
	cxx_std_11
	cxx_nullptr
)

# Add the path to FindBerkeleyDB.cmake to our modules path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../")

# Find the package
find_package(BerkeleyDB REQUIRED)

# Link the imported target
target_link_libraries(findbdb-test PRIVATE Oracle::BerkeleyDB)

# Create a test with ctest support
include(CTest)
add_test(NAME "FindTest" COMMAND "findbdb-test")
