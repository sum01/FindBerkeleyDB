# FindBerkeleyDB.cmake

This module finds [Berkeley DB](http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html), then outputs the paths of the include & libs folders into public vars.

**Note:** Only tested on v5 & v6 of Berkeley DB.

## Usage

I recommend making a `cmake/modules` at your project's root to hold modules.

### As a git submodule

`git submodule add https://github.com/sum01/FindBerkeleyDB.git` into your preferred folder location in your project.  
I would recommend doing this so that you can update the module under version control.

## In CmakeLists.txt

Put `list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/FindBerkeleyDB")` before using the functionality (making sure to change the path based on where you placed it).  
This allows for `find_package(BerkeleyDB)` to be called once the path is appended.

`find_package(BerkeleyDB "5.23.0")` declares the `BERKELEYDB_INCLUDE_DIRS` & `BERKELEYDB_LIBRARIES` variables to be used.

**Example usage in CmakeLists.txt**

```cmake
CMAKE_MINIMUM_REQUIRED(VERSION 3.0 FATAL_ERROR)
project(Example VERSION "1.2.3" LANGUAGES CXX)

# Remember to change the path to fit your folder layout
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/FindBerkeleyDB")

# Calling the module
find_package(BerkeleyDB "5.23.0" REQUIRED)

# Example executable
add_executable(my_exe main.cpp)

# Actually linking to the found libraries/includes
target_link_libraries(my_exe PRIVATE ${BERKELEYDB_LIBRARIES})
# Linking with BUILD_INTERFACE is needed if exporting your exe/lib
target_include_directories(my_exe
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  PRIVATE ${BERKELEYDB_INCLUDE_DIRS}
)
```
