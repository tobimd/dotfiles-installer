# It's important to specify the minimum CMake version upfront required by
# CMakeLists.txt. This is so that a user can clearly understand the reason the 
# build will fail before the build actually occurs, instead of searching for the
# CMake function that was used that is causing the failure.
cmake_minimum_required(VERSION 3.1)

# Set the global package-wide C++ standard. This will be inherited by all
# targets specified in the project. One can also specify the C++ standard in a
# target-specific manner, using:
#   set_target_properties(foo PROPERTIES CXX_STANDARD 11)
#   target_compile_features(foo PUBLIC cxx_std_14)
# together.
set(CMAKE_CXX_STANDARD 11)

# Set the project name and version number. This allows for a user of your
# library or tool to specify a particular version when they include it, as in 
#   find_package(tdi 1.0 REQUIRED)
project(tdi VERSION 1.0)
set(tdi_VERSION 1.0)

# enable unit testing via "make test" once the code has been compiled.
include(CTest)

# Function to prepend the subdirectory to source files in subdirectories
FUNCTION(PREPEND var )
   SET(listVar "")
   FOREACH(f ${${var}})
       LIST(APPEND listVar "${CMAKE_CURRENT_SOURCE_DIR}/${f}")
   ENDFOREACH(f)
   SET(${var} "${listVar}" PARENT_SCOPE)
ENDFUNCTION(PREPEND)

# After a normal build, we can specify the location of various outputs of the
# build. We put executables and static libraries outside the build directory in
# bin/ and lib/, respectively.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib")

# Find fmt on the system.
find_package(fmt REQUIRED)

# Include source code and headers. This calls the CMakeLists.txt in each
# subdirectory. These can define their own libraries, executables, etc. as targets, 
# but here we define all exportable targets in the root CMakeLists.txt.
add_subdirectory(src)
add_subdirectory(include)

# Add the test directory. It is optional and can be disabled during with
#   cmake -DBUILD_TESTING=OFF ..
# To run unit tests produced here, we only need to run:
#   make test
# or
#   ctest 
# In case your tests are printing to console, you can view their output to
# stdout with:
#   ctest -V

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

# Add the library tdi as a target, with the contents of src/ and include/
# as dependencies.
add_library(tdi STATIC ${tdi_SRC} ${tdi_INC})

# These variables slightly modify the install location to allow for version
# specific installations.
set(tdi_INCLUDE_DEST "include/tdi-${tdi_VERSION}")
set(tdi_LIB_DEST "lib/tdi-${tdi_VERSION}")


# generator expressions are needed for the include directories, since installing headers changes the include path
# Specify that tdi requires the files located in the include/ directory at
# compile time. This would normally look like 
#   target_include_directories(tdi PUBLIC include/)
# PUBLIC means that other libraries including tdi should also include the
# directory include/.
# However, there is a catch. If we are installing the project in
# CMAKE_INSTALL_PREFIX, we can't specify include/ in the build directory: we have 
# copied the contents of include to CMAKE_INSTALL_PREFIX/include and we would
# like  other projects to include this directory instead of include/. The follow
# CMake command handles this. $<BUILD_INTERFACE:...> and
# $<INSTALL_INTERFACE:...> are macros whose values change depending on if we are
# simply building the code or if we are installing it.
target_include_directories(tdi PUBLIC
   # headers to include when building from source
   $<BUILD_INTERFACE:${tdi_SOURCE_DIR}/include> 
   $<BUILD_INTERFACE:${tdi_BINARY_DIR}/include> 

   # headers to include when installing  (implicitly prefixes with ${CMAKE_INSTALL_PREFIX}).
   $<INSTALL_INTERFACE:include> 
   )

# As an example, assume we want to use the LAPACK library:
# Specify that tdi requires LAPACK to link properly. Ideally, LAPACK would
# specify LAPACK::LAPACK for linking so that we can avoid using the variables.
# However, each package is different and one must check the documentation to 
# see what variables are defined. The following is what should be used in this
# case:
# target_link_libraries(tdi ${LAPACK_LIBRARIES})
target_link_libraries(tdi fmt::fmt)

# Install tdi in CMAKE_INSTALL_PREFIX (defaults to /usr/local on linux). 
# To change the install location, run 
#   cmake -DCMAKE_INSTALL_PREFIX=<desired-install-path> ..

# install(...) specifies installation rules for the project. It can specify
# location of installed files on the system, user permissions, build
# configurations, etc. Here, we are only copying files.
# install(TARGETS ...) specifies rules for installing targets. 
# Here, we are taking a target or list of targets (tdi) and telling CMake
# the following:
#   - put shared libraries associated with tdi in ${tdi_LIB_DEST}
#   - put static libraries associated with tdi in ${tdi_LIB_DEST}
#   - put include files associated with tdi in ${tdi_INCLUDE_DEST}
# We also need to specify the export that is associated with tdi; an export 
# is just a list of targets to be installed.
# So we are associating tdi with tdiTargets.
install(
    # targets to install
    TARGETS tdi 
    # name of the CMake "export group" containing the targets we want to install
    EXPORT tdiTargets
    # Dynamic, static library and include destination locations after running
    # "make install"
    LIBRARY DESTINATION ${tdi_LIB_DEST}
    ARCHIVE DESTINATION ${tdi_LIB_DEST} 
    INCLUDES DESTINATION ${tdi_INCLUDE_DEST}
    )

# We now need to install the export tdiTargets that we defined above. This
# is needed in order for another project to import tdi using 
#   find_package(tdi)
# find_package(tdi) will look for tdi-config.cmake to provide
# information about the targets contained in the project tdi. Fortunately,
# this is specified in the export tdiTargets, so we will install this too.
# install(EXPORT ...) will install the information about an export. Here, we
# save it to a file {$tdi_LIB_DEST}/tdiTargets.cmake and prepend 
# everything inside tdiTargets  with the namespace tdi::.
install(
    # The export we want to save (matches name defined above containing the
    # install targets)
    EXPORT tdiTargets
    # CMake file in which to store the export's information
    FILE  tdiTargets.cmake
    # Namespace prepends all targets in the export (when we import later, we
    # will use tdi::tdi)
    NAMESPACE tdi::
    # where to place the resulting file (here, we're putting it with the library)
    DESTINATION ${tdi_LIB_DEST}
    )

# install(FILES ...) simply puts files in a certain place with certain
# properties. We're just copying them to the desired place here.
install(FILES ${tdi_INC} DESTINATION ${tdi_INCLUDE_DEST})

# Write a "version file" in case some wants to only load a particular version of
# tdi @BUG this fails at the moment.
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    tdiConfigVersion.cmake
    VERSION ${tdi_VERSION}
    COMPATIBILITY AnyNewerVersion
    )

# Copies the resulting CMake config files to the installed library directory
install(
    FILES 
        "cmake/tdi-config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/tdiConfigVersion.cmake"
    DESTINATION ${tdi_LIB_DEST}
    )

