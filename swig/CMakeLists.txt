########################################################
# CMakeLists.txt for RubyFits
########################################################

cmake_minimum_required(VERSION 2.8)

### Initial definition of cmake variables
set(CMAKE_INSTALL_PREFIX $ENV{HOME} CACHE PATH "install prefix")
set(CMAKE_BUILD_TYPE Release CACHE STRING "build type")
set(CMAKE_CXX_FLAGS_DEBUG "-g -W -Wall" CACHE STRING "CXX_FLAGS for debug")
set(CMAKE_C_FLAGS_DEBUG "-g -W -Wall" CACHE STRING "C_FLAGS for debug")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -W -Wall" CACHE STRING "CXX_FLAGS for release")
set(CMAKE_C_FLAGS_RELEASE "-O3 -W -Wall" CACHE STRING "C_FLAGS for release")

### Definition of project
project(RubyFits)
message("-- Install destination prefix: ${CMAKE_INSTALL_PREFIX}")
set(TARGET_EXT_LIBRARY fits)
set(SWIG_IF_FILE ${TARGET_EXT_LIBRARY}.i)

### dependent libraries (SLLIB and SFITSIO)
#### Install these libraries with Homebrew
#### > brew install sfitsio sllib
set(LIBSLLIB "sllib") #this could be a dynamic link
set(LIBSFITSIO "libsfitsio.a")

### compile option (Debug) 
set(CMAKE_CXX_FLAGS_DEBUG "-W -g")
set(CMAKE_C_FLAGS_DEBUG "-W -g")

### compile option (Release)
set(CMAKE_CXX_FLAGS_RELEASE "-O2")
set(CMAKE_C_FLAGS_RELEASE "-O2")

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

find_package(Ruby)
set(RUBY_LINK_FLAGS " ")
if(${RUBY_VERSION} VERSION_GREATER 1.9.0)
  set(RUBY_INCLUDE_DIRS ${RUBY_HDR_DIR})
  set(RUBY_LIBRARY "")
  if(APPLE)
    set(RUBY_LINK_FLAGS "-Wl,-undefined,dynamic_lookup -Wl,-multiply_defined,suppress -Wl,-flat_namespace")
  endif()
endif()

message("-- Ruby include: ${RUBY_INCLUDE_DIRS}")
message("-- Ruby library: ${RUBY_LIBRARY}")

include_directories(
  ../include
  .
  ${RUBY_INCLUDE_DIRS}
)

link_directories(
  /usr/local/lib
)

set(CMAKE_SWIG_FLAGS "")

set_source_files_properties(${SWIG_IF_FILE} PROPERTIES CPLUSPLUS ON)
# set_source_files_properties(${SWIG_IF_FILE} PROPERTIES SWIG_FLAGS "-includeall")
# set_source_files_properties(${SWIG_IF_FILE} PROPERTIES SWIG_FLAGS "-minherit")
set_source_files_properties(${SWIG_IF_FILE} PROPERTIES SWIG_FLAGS "-autorename")
add_definitions(-DHAVE_STRUCT_TIMESPEC -DHAVE_SIGNBIT)
swig_add_module(${TARGET_EXT_LIBRARY} ruby ${SWIG_IF_FILE})
swig_link_libraries(${TARGET_EXT_LIBRARY} ${RUBY_LIBRARY} ${LIBSLLIB} ${LIBSFITSIO} )

if(APPLE)
  set(RUBY_BINDING_SUFFIX ".bundle")
else(APPLE)
  set(RUBY_BINDING_SUFFIX ".so")
endif(APPLE)

set_target_properties(${TARGET_EXT_LIBRARY}
  PROPERTIES
  PREFIX ""
  SUFFIX ${RUBY_BINDING_SUFFIX}
  LINK_FLAGS ${RUBY_LINK_FLAGS}
  )

install(TARGETS ${TARGET_EXT_LIBRARY}
  LIBRARY
  DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/ruby)

install(FILES RubyFits.rb
  DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/ruby)
