# FindBerkeleyDB.cmake

This provides a [Cmake](https://cmake.org/) [find_packge module](https://cmake.org/cmake/help/latest/command/find_package.html) for [Berkeley DB](http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html).

Tested on v5 & v6 of Berkeley DB.

## Usage

Put `list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/FindBerkeleyDB")` before running `find_package`. Make sure to change the path if it doesn't match your project.\
Once the module's path is appended to `CMAKE_MODULE_PATH`, `find_package(BerkeleyDB)` can be called.

All libraries are searched for, but as long as one is found the build will pass. It does fail if none are found, so no header-only support.

### List of available variables

| Variable                   | Provides                                               |
| :------------------------- | :----------------------------------------------------- |
| `BERKELEYDB_VERSION`       | The full version (major.minor.patch)                   |
| `BERKELEYDB_MAJOR_VERSION` | Just the major version                                 |
| `BERKELEYDB_MINOR_VERSION` | Just the minor version                                 |
| `BERKELEYDB_PATCH_VERSION` | Just the patch version (with `NC` if non-crypto)       |
| `BERKELEYDB_IS_NC`         | True/false if the found BerkeleyDB is non-crypto       |
| `BERKELEYDB_INCLUDE_DIRS`  | The path to the header file directory                  |
| `BERKELEYDB_LIBRARIES`     | A list of the paths to all found libraries             |
| `BERKELEYDB_LIBDB`         | The path to the `db` library. `false` if not found     |
| `BERKELEYDB_LIBDB_CXX`     | The path to the `db_cxx` library. `false` if not found |
| `BERKELEYDB_LIBDB_STL`     | The path to the `db_stl` library. `false` if not found |
| `BERKELEYDB_LIBDB_SQL`     | The path to the `db_sql` library. `false` if not found |

### As a git submodule

I would recommend using this as a submodule so that you can update it under version control.

Run `git submodule add https://github.com/sum01/FindBerkeleyDB.git` at your preferred folder location in your project.

#### Example usage in CmakeLists.txt

```cmake
CMAKE_MINIMUM_REQUIRED(VERSION 3.3.0 FATAL_ERROR)
project(Example VERSION 1.2.3 LANGUAGES CXX)

# Remember to change the path to fit your folder layout!
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules/FindBerkeleyDB")

# Calling the module
find_package(BerkeleyDB "5.23.0" REQUIRED)

# Example executable
add_executable(my_exe main.cpp)

# Actually linking to the found libraries/includes
target_link_libraries(my_exe
	PRIVATE ${BERKELEYDB_LIBRARIES}
)

target_include_directories(my_exe
  PRIVATE ${BERKELEYDB_INCLUDE_DIRS}
)
```
