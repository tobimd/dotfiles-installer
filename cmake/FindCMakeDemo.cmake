# - Try to find the tdi library
# Once done this will define
#
#  tdi_FOUND - system has tdi
#  tdi_INCLUDE_DIR - tdi include directory
#  tdi_LIB - tdi library directory
#  tdi_LIBRARIES - tdi libraries to link

if(tdi_FOUND)
    return()
endif()

# We prioritize libraries installed in /usr/local with the prefix .../tdi-*, 
# so we make a list of them here
file(GLOB lib_glob "/usr/local/lib/tdi-*")
file(GLOB inc_glob "/usr/local/include/tdi-*")

# Find the library with the name "tdi" on the system. Store the final path
# in the variable tdi_LIB
find_library(tdi_LIB 
    # The library is named "tdi", but can have various library forms, like
    # libtdi.a, libtdi.so, libtdi.so.1.x, etc. This should
    # search for any of these.
    NAMES tdi
    # Provide a list of places to look based on prior knowledge about the system.
    # We want the user to override /usr/local with environment variables, so
    # this is included here.
    HINTS
        ${tdi_DIR}
        ${TDI_DIR}
        $ENV{tdi_DIR}
        $ENV{TDI_DIR}
        ENV TDI_DIR
    # Provide a list of places to look as defaults. /usr/local shows up because
    # that's the default install location for most libs. The globbed paths also
    # are placed here as well.
    PATHS
        /usr
        /usr/local
        /usr/local/lib
        ${lib_glob}
    # Constrain the end of the full path to the detected library, not including
    # the name of library itself.
    PATH_SUFFIXES 
        lib
)

# Find the path to the file "source_file.hpp" on the system. Store the final
# path in the variables tdi_INCLUDE_DIR. The HINTS, PATHS, and
# PATH_SUFFIXES, arguments have the same meaning as in find_library().
find_path(tdi_INCLUDE_DIR source_file.hpp
    HINTS
        ${tdi_DIR}
        ${TDI_DIR}
        $ENV{tdi_DIR}
        $ENV{TDI_DIR}
        ENV TDI_DIR
    PATHS
        /usr
        /usr/local
        /usr/local/include
        ${inc_glob}
    PATH_SUFFIXES 
        include
)


# Check that both the paths to the include and library directory were found.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(tdi
    "\ntdi not found --- You can download it using:\n\tgit clone 
    https://github.com/mmorse1217/cmake-project-template\n and setting the TDI_DIR environment variable accordingly"
    tdi_LIB tdi_INCLUDE_DIR)

# These variables don't show up in the GUI version of CMake. Not required but
# people seem to do this...
mark_as_advanced(tdi_INCLUDE_DIR tdi_LIB)

# Finish defining the variables specified above. Variables names here follow
# CMake convention.
set(tdi_INCLUDE_DIRS ${tdi_INCLUDE_DIR})
set(tdi_LIBRARIES ${tdi_LIB})

# If the above CMake code was successful and we found the library, and there is
# no target defined, lets make one.
if(tdi_FOUND AND NOT TARGET tdi::tdi)
    add_library(tdi::tdi UNKNOWN IMPORTED)
    # Set location of interface include directory, i.e., the directory
    # containing the header files for the installed library
    set_target_properties(tdi::tdi PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${tdi_INCLUDE_DIRS}"
        )

    # Set location of the installed library
    set_target_properties(tdi::tdi PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${tdi_LIBRARIES}"
        )
endif()
