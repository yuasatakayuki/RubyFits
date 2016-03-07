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
set(LIBSFITSIO "sfitsio")

if(APPLE)
  set(sharedlib_SUFFIX "dyld")
  message("-- Share library suffix = ${sharedlib_SUFFIX}")
else(APPLE)
  set(sharedlib_SUFFIX "so")
  message("-- Share library suffix = ${sharedlib_SUFFIX}")
endif(APPLE)

find_path(sllib_INC_DIR
  NAMES sli/mdarray.h sli/slierr.h
  PATHS /usr/local/include /usr/include $ENV{HOME}/.linuxbrew/include $ENV{HOME}/work/install/include )
 
message("-- sllib include path: ${sllib_INC_DIR}")
 
find_path(sllib_LIB_DIR
  NAMES libsllib.${sharedlib_SUFFIX} libsllib.dylib
  PATHS /usr/local/lib /usr/local/lib64 /usr/lib /usr/lib64 $ENV{HOME}/.linuxbrew/lib/* $ENV{HOME}/.linuxbrew/lib64/* $ENV{HOME}/work/install/lib/* $ENV{HOME}/work/install/lib64/* )
 
message("-- sllib lib path: ${sllib_LIB_DIR}")

### compile option (Debug) 
set(CMAKE_CXX_FLAGS_DEBUG "-W -g")
set(CMAKE_C_FLAGS_DEBUG "-W -g")

### compile option (Release)
set(CMAKE_CXX_FLAGS_RELEASE "-O2")
set(CMAKE_C_FLAGS_RELEASE "-O2")

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

find_package(Ruby)

message("-- RUBY_HDR_DIR = ${RUBY_HDR_DIR}")

set(RUBY_LINK_FLAGS " ")
find_path(RUBY_CONFIG_FILE_DIR
  NAMES ruby/config.h
  PATHS ${RUBY_HDR_DIR}/* /usr/include
  NO_DEFAULT_PATH
)


find_path(RUBY_LIBRARY
  NAMES socket.${sharedlib_SUFFIX}
  PATHS /usr/lib/ruby /usr/lib64/ruby
  NO_DEFAULT_PATH
)

if(${RUBY_VERSION} VERSION_GREATER 1.9.0)
  set(RUBY_INCLUDE_DIRS ${RUBY_HDR_DIR} ${RUBY_CONFIG_FILE_DIR})
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
  ${sllib_INC_DIR}
)

link_directories(
  /usr/local/lib
  ${sllib_LIB_DIR}
)

set(CMAKE_SWIG_FLAGS "")

set_source_files_properties(${SWIG_IF_FILE} PROPERTIES CPLUSPLUS ON)
# set_source_files_properties(${SWIG_IF_FILE} PROPERTIES SWIG_FLAGS "-includeall")
# set_source_files_properties(${SWIG_IF_FILE} PROPERTIES SWIG_FLAGS "-minherit")
set_source_files_properties(${SWIG_IF_FILE} PROPERTIES SWIG_FLAGS "-autorename")
add_definitions(-DHAVE_STRUCT_TIMESPEC -DHAVE_STRUCT_TIMEVAL -DHAVE_SIGNBIT)
swig_add_module(${TARGET_EXT_LIBRARY} ruby ${SWIG_IF_FILE})
swig_link_libraries(${TARGET_EXT_LIBRARY} ${RUBY_LIBRARY} ${LIBSFITSIO} ${LIBSLLIB})

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
