# FindBerkeleyDB.cmake - version 2.1.0
# Author: sum01 <sum01@protonmail.com>
# Git: https://github.com/sum01/FindBerkeleyDB
# Read the README.md for the full info.

# NOTE: If Berkeley DB ever gets a Pkg-config ".pc" file, add pkg_check_modules() here

# Checks if environment paths are empty, set them if they aren't
IF(NOT "$ENV{BERKELEYDB_ROOT}" STREQUAL "")
  set(_BERKELEYDB_HINTS "$ENV{BERKELEYDB_ROOT}")
ELSEIF(NOT "$ENV{BERKELEYDBROOT}" STREQUAL "")
  set(_BERKELEYDB_HINTS "$ENV{BERKELEYDBROOT}")
ELSE()
  # Set just in case, as it's used regardless if it's empty or not
  set(_BERKELEYDB_HINTS "")
ENDIF()

# Allow user to pass a path instead of guessing
IF(BERKELEYDB_ROOT)
  set(_BERKELEYDB_PATHS "${BERKELEYDB_ROOT}")
ELSEIF(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  # Shameless copy-paste from FindOpenSSL.cmake v3.8
  file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" _programfiles)
  list(APPEND _BERKELEYDB_HINTS "${_programfiles}")

  # There's actually production release and version numbers in the file path.
  # For example, if they're on v6.2.32: C:/Program Files/Oracle/Berkeley DB 12cR1 6.2.32/
  # But this still works to find it, so I'm guessing it can accept partial path matches.

  foreach(_TARGET_BERKELEYDB_PATH "Oracle/Berkeley DB" "Berkeley DB")
    list(APPEND _BERKELEYDB_PATHS
      "${_programfiles}/${_TARGET_BERKELEYDB_PATH}"
      "C:/Program Files (x86)/${_TARGET_BERKELEYDB_PATH}"
      "C:/Program Files/${_TARGET_BERKELEYDB_PATH}"
      "C:/${_TARGET_BERKELEYDB_PATH}"
    )
  endforeach()
ELSE()
  # Paths for anything other than Windows
  # Cellar/berkeley-db is for macOS from homebrew installation
  list(APPEND _BERKELEYDB_PATHS
    "/usr"
    "/usr/local"
    "/usr/local/Cellar/berkeley-db"
    "/opt"
    "/opt/local"
  )
ENDIF()

# Find includes path
find_path(BERKELEYDB_INCLUDE_DIRS
  NAMES "db.h" "db_cxx.h"
  HINTS ${_BERKELEYDB_HINTS}
  PATH_SUFFIXES "include" "includes"
  PATHS ${_BERKELEYDB_PATHS}
)

# Checks if the version file exists, save the version file to a var, and fail if there's no version file
IF(BERKELEYDB_INCLUDE_DIRS AND EXISTS "${BERKELEYDB_INCLUDE_DIRS}/db.h")
  set(_BERKELEYDB_VERSION_file "${BERKELEYDB_INCLUDE_DIRS}/db.h")
ELSE()
  message(FATAL_ERROR "Failed to find Berkeley DB's header file \"db.h\"! Try setting \"BERKELEYDB_ROOT\" when initiating Cmake.")
ENDIF()

# Read the version file db.h into a variable
file(READ ${_BERKELEYDB_VERSION_file} _BERKELEYDB_header_contents)
# Parse the DB version into variables to be used in the lib names
string(REGEX REPLACE ".*DB_VERSION_MAJOR	([0-9]+).*" "\\1" BERKELEYDB_MAJOR_VERSION "${_BERKELEYDB_header_contents}")
string(REGEX REPLACE ".*DB_VERSION_MINOR	([0-9]+).*" "\\1" BERKELEYDB_MINOR_VERSION "${_BERKELEYDB_header_contents}")
# Patch version example on non-crypto installs: x.x.xNC
string(REGEX REPLACE ".*DB_VERSION_PATCH	([0-9]+(NC)?).*" "\\1" BERKELEYDB_PATCH_VERSION "${_BERKELEYDB_header_contents}")
# The actual returned/output version variable (the others can be used if needed)
set(BERKELEYDB_VERSION "${BERKELEYDB_MAJOR_VERSION}.${BERKELEYDB_MINOR_VERSION}.${BERKELEYDB_PATCH_VERSION}")

# True/false if the found BerkeleyDB is non-crypto
IF(BERKELEYDB_PATCH_VERSION MATCHES "[0-9]+(NC)")
	set(BERKELEYDB_IS_NC true)
ELSE()
	set(BERKELEYDB_IS_NC false)
ENDIF()

# Finds the target library for berkeley db, since they all follow the same naming conventions
macro(findpackage_berkeleydb_get_lib _BERKELEYDB_OUTPUT_VARNAME _TARGET_BERKELEYDB_LIB)
  # Different systems sometimes have a version in the lib name...
  # and some have a dash or underscore before the versions.
  # CMake recommends to put unversioned names before versioned names
  find_library(${_BERKELEYDB_OUTPUT_VARNAME}
    NAMES
			"${_TARGET_BERKELEYDB_LIB}"
			"lib${_TARGET_BERKELEYDB_LIB}"
			"lib${_TARGET_BERKELEYDB_LIB}${BERKELEYDB_MAJOR_VERSION}.${BERKELEYDB_MINOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}-${BERKELEYDB_MAJOR_VERSION}.${BERKELEYDB_MINOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}_${BERKELEYDB_MAJOR_VERSION}.${BERKELEYDB_MINOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}${BERKELEYDB_MAJOR_VERSION}${BERKELEYDB_MINOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}-${BERKELEYDB_MAJOR_VERSION}${BERKELEYDB_MINOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}_${BERKELEYDB_MAJOR_VERSION}${BERKELEYDB_MINOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}${BERKELEYDB_MAJOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}-${BERKELEYDB_MAJOR_VERSION}"
			"lib${_TARGET_BERKELEYDB_LIB}_${BERKELEYDB_MAJOR_VERSION}"
    HINTS ${_BERKELEYDB_HINTS}
    PATH_SUFFIXES "lib" "lib64" "libs" "libs64"
    PATHS ${_BERKELEYDB_PATHS}
  )
  # If the library was found, add it to our list of libraries
  IF(${_BERKELEYDB_OUTPUT_VARNAME})
	  # If found, append to our libraries variable
		# The ${{}} is because the first expands to target the real variable, the second expands the variable's contents...
		# and the real variable's contents is the path to the lib. Thus, it appends the path of the lib to BERKELEYDB_LIBRARIES.
		list(APPEND BERKELEYDB_LIBRARIES "${${_BERKELEYDB_OUTPUT_VARNAME}}")
	ELSE()
		# If not found, set to false for the user to easily check
		set(${_BERKELEYDB_OUTPUT_VARNAME} false)
  ENDIF()
	# Only show in the GUI if they click "advanced". Does nothing when using the CLI.
	mark_as_advanced(FORCE ${_BERKELEYDB_OUTPUT_VARNAME})
endmacro()

# Find and set the variables (if in COMPONENTS) to the paths of the libraries
findpackage_berkeleydb_get_lib(BERKELEYDB_LIBDB "db")
# Windows doesn't have a db_cxx lib, but instead compiles the cxx code into the "db" lib
findpackage_berkeleydb_get_lib(BERKELEYDB_LIBDB_CXX "db_cxx")
# I don't think Linux/Unix gets an SQL lib...
findpackage_berkeleydb_get_lib(BERKELEYDB_LIBDB_SQL "db_sql")
findpackage_berkeleydb_get_lib(BERKELEYDB_LIBDB_STL "db_stl")

# Needed for find_package_handle_standard_args()
include(FindPackageHandleStandardArgs)
# Fails if required vars aren't found, or if the version doesn't meet specifications.
find_package_handle_standard_args(BerkeleyDB
  FOUND_VAR BERKELEYDB_FOUND # "FOUND_VAR is obsolete and only for older versions of cmake."
  REQUIRED_VARS BERKELEYDB_INCLUDE_DIRS BERKELEYDB_LIBRARIES
  VERSION_VAR BERKELEYDB_VERSION
)

# Only show the includes path and libraries in the GUI if they click "advanced".
# Does nothing when using the CLI
mark_as_advanced(FORCE
	BERKELEYDB_INCLUDE_DIRS
	BERKELEYDB_LIBRARIES
)

# A message that tells the user what includes/libs were found, and obeys the QUIET command.
find_package_message(BerkeleyDB
	"Found BerkeleyDB libraries: ${BERKELEYDB_LIBRARIES}"
	"[${BERKELEYDB_LIBRARIES}[${BERKELEYDB_INCLUDE_DIRS}]]"
)
