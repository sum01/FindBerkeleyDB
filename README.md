# FindBerkeleyDB.cmake

[![Build Status](https://travis-ci.com/sum01/FindBerkeleyDB.svg?branch=master)](https://travis-ci.com/sum01/FindBerkeleyDB)

This provides a [Cmake](https://cmake.org/) [find_packge module](https://cmake.org/cmake/help/latest/command/find_package.html) for [Berkeley DB](http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html).

Tested on v5 & v6 of Berkeley DB.

## Usage

An `Oracle::BerkeleyDB` [IMPORTED library](https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html#imported-targets) is created for easy linking.

```cmake
# Make sure to change the path if it doesn't match your project.
# This is pointing to the folder FindBerkeleyDB, not the actual Cmake file
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/FindBerkeleyDB")
# Link to the IMPORTED library to get the includes and libs
target_link_libraries(yourexeorlib PRIVATE Oracle::BerkeleyDB)
```

All libraries are searched for, but as long as one is found the build will pass. It does fail if none are found, so no header-only support.

### List of available variables

| Variable                   | Provides                                         |
| :------------------------- | :----------------------------------------------- |
| `BerkeleyDB_VERSION`       | The full version (major.minor.patch)             |
| `BerkeleyDB_VERSION_MAJOR` | Just the major version                           |
| `BerkeleyDB_VERSION_MINOR` | Just the minor version                           |
| `BerkeleyDB_VERSION_PATCH` | Just the patch version (with `NC` if non-crypto) |
| `BerkeleyDB_INCLUDE_DIRS`  | The path to the header file directory            |
| `BerkeleyDB_LIBRARIES`     | A list of the paths to all found libraries       |
| `BerkeleyDB_LIBRARY`       | The path to the `db` library, or `-NOTFOUND`     |
| `BerkeleyDB_Cxx_LIBRARY`   | The path to the `db_cxx` library, or `-NOTFOUND` |
| `BerkeleyDB_Stl_LIBRARY`   | The path to the `db_stl` library, or `-NOTFOUND` |
| `BerkeleyDB_Sql_LIBRARY`   | The path to the `db_sql` library, or `-NOTFOUND` |

## Notes

Use `BerkeleyDB_ROOT_DIR` to help find the library if it's not automatically found.\
Example: `cmake -DBerkeleyDB_ROOT_DIR="C:/some/weird/path/Berkeley DB" ..`

On certain operating systems, different libraries may or may not exist.\
It is best to not use the `xxx_LIBRARY` variables directly...\
Instead, use the imported target `Oracle::BerkeleyDB` or the `BerkeleyDB_LIBRARIES` variable.
